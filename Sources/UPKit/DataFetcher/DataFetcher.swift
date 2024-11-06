//
//  DataFetcher.swift
//  JNGLBK
//
//  Created by Utsav Patel on 05/11/2024.
//

import Foundation
import UIKit

public class DataFetcher<T: Decodable> {
    private let fileManager: FileManager
    private var baseURL: String?
    
    private var localDirectoryURL: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    public init(fileManager: FileManager, baseURL: String) {
        self.baseURL = baseURL
        self.fileManager = fileManager
    }
    
    public func fetchConfigData(completion: @escaping (Result<(ConfigModel, [T]), Error>) -> Void) {
        guard let baseURL = baseURL else {
            return completion(.failure(DataFetcherError.baseURLNotSet))
        }
        
        fetchData(from: "\(baseURL)/config.json") { result in
            switch result {
                case .success(let data):
                    self.processFetchedConfigData(data, completion: completion)
                case .failure(let error):
                    self.handleLocalConfigFallback(completion: completion, error: error)
            }
        }
    }
    
    private func processFetchedConfigData(_ data: Data, completion: @escaping (Result<(ConfigModel, [T]), Error>) -> Void) {
        switch decode(data) as Result<ConfigModel, Error> {
            case .success(let decodedConfig):
                let localConfig = loadLocalConfig()
                let isNewConfigVersion = localConfig == nil || decodedConfig.version > localConfig!.version
                
                if isNewConfigVersion {
                    clearLocalData()
                    do {
                        try save(data: data, to: "data.json")
                    } catch {
                        return completion(.failure(DataFetcherError.saveFailed(error)))
                    }
                    
                    downloadAllData(for: decodedConfig.items) { itemModels in
                        completion(.success((decodedConfig, itemModels)))
                    }
                } else {
                    do {
                        let localData = try loadAllData(for: decodedConfig.items)
                        completion(.success((localConfig!, localData)))
                    } catch {
                        completion(.failure(DataFetcherError.loadFailed(error)))
                    }
                }
            case .failure(let decodeError):
                completion(.failure(decodeError))
        }
    }
    
    private func handleLocalConfigFallback(completion: @escaping (Result<(ConfigModel, [T]), Error>) -> Void, error: Error) {
        if let localConfig = loadLocalConfig() {
            do {
                let localData = try loadAllData(for: localConfig.items)
                completion(.success((localConfig, localData)))
            } catch {
                completion(.failure(DataFetcherError.loadFailed(error)))
            }
        } else {
            completion(.success((ConfigModel(version: 0, items: []), [])))
        }
    }
    
    private func fetchData(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion(.failure(DataFetcherError.invalidURL(urlString)))
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(DataFetcherError.noDataReceived(urlString)))
            }
        }.resume()
    }
    
    private func save(data: Data, to fileName: String) throws {
        let fileURL = localDirectoryURL.appendingPathComponent(fileName)
        let directoryURL = fileURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try data.write(to: fileURL, options: .atomic)
    }
    
    private func loadLocalConfig() -> ConfigModel? {
        do {
            return try loadLocalData(from: "data.json")
        } catch {
            print("Failed to load local config: \(error)")
            return nil
        }
    }
    
    private func loadLocalData<U: Decodable>(from fileName: String) throws -> U? {
        let localFileURL = localDirectoryURL.appendingPathComponent(fileName)
        let data = try Data(contentsOf: localFileURL)
        return try decode(data).get()
    }
    
    private func downloadAllData(for items: [Group], completion: @escaping ([T]) -> Void) {
        var itemModels: [T] = []
        let dispatchGroup = DispatchGroup()
        
        for item in items {
            dispatchGroup.enter()
            let dataURLString = "\(baseURL!)/\(item.title.lowercased())/data.json"
            
            fetchData(from: dataURLString) { result in
                switch result {
                    case .success(let data):
                        do {
                            try self.save(data: data, to: "\(item.title.lowercased())/data.json")
                            if let itemModel: T = try? self.decode(data).get() {
                                itemModels.append(itemModel)
                            }
                        } catch {
                            print("Error saving data for \(item.title): \(error)")
                        }
                    case .failure:
                        do {
                            if let localData: T = try self.loadLocalData(from: "\(item.title.lowercased())/data.json") {
                                itemModels.append(localData)
                            }
                        } catch {
                            print("Error loading local data for \(item.title): \(error)")
                        }
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(itemModels)
        }
    }
    
    private func loadAllData(for items: [Group]) throws -> [T] {
        return try items.compactMap { item in
            try loadLocalData(from: "\(item.title.lowercased())/data.json")
        }
    }
    
    private func clearLocalData() {
        guard let localFiles = try? fileManager.contentsOfDirectory(at: localDirectoryURL, includingPropertiesForKeys: nil) else { return }
        
        for fileURL in localFiles {
            do {
                try fileManager.removeItem(at: fileURL)
            } catch {
                print("Failed to delete local file \(fileURL): \(error)")
            }
        }
    }
    
    private func decode<U: Decodable>(_ data: Data) -> Result<U, Error> {
        do {
            let decodedData = try JSONDecoder().decode(U.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(DataFetcherError.decodeFailed(error))
        }
    }
}

public enum DataFetcherError: LocalizedError {
    case baseURLNotSet
    case invalidURL(String)
    case noDataReceived(String)
    case saveFailed(Error)
    case loadFailed(Error)
    case decodeFailed(Error)
    
    public var errorDescription: String? {
        switch self {
            case .baseURLNotSet: return "Base URL is not set."
            case .invalidURL(let urlString): return "Invalid URL: \(urlString)"
            case .noDataReceived(let urlString): return "No data received from \(urlString)"
            case .saveFailed(let error): return "Failed to save data: \(error.localizedDescription)"
            case .loadFailed(let error): return "Failed to load data: \(error.localizedDescription)"
            case .decodeFailed(let error): return "Failed to decode data: \(error.localizedDescription)"
        }
    }
}

public struct ConfigModel: Codable {
    public let version: Int
    public let items: [Group]
}

public struct Group: Codable {
    public let id: Int
    public let title: String
}
