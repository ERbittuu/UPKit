//
//  CheckUpdate.swift
//  UPKit
//
//  Created by Utsav Patel on 01/10/2024.
//

import Foundation

    // MARK: - CheckUpdate Class
public class CheckUpdate: NSObject {
    
        // MARK: - Singleton Instance
    public static let shared = CheckUpdate()
    
        // MARK: - Predefined App Info Variables (public if needed elsewhere)
    public var currentVersion: String = "1.0.0"  // Set your app's current version
    public var bundleIdentifier: String = "com.example.myapp"  // Set your app's bundle identifier
    public var appName: String = "MyApp"  // Set your app's name
    
        // MARK: - Public Function to Check and Show Update
        /// Checks for an update and returns update information.
    public func checkAndShowUpdate(completion: @escaping (UpdateInfo?) -> Void) {
        DispatchQueue.global().async {
            self.checkVersion { updateInfo in
                DispatchQueue.main.async {
                    completion(updateInfo)  // Return update information on the main thread.
                }
            }
        }
    }
    
        // MARK: - Private Function to Check Version
        /// Checks the current version against the App Store version.
    private func checkVersion(completion: @escaping (UpdateInfo?) -> Void) {
        let currentVersion = currentVersion  // Current app version (replace with a variable as needed)
        let identifier = bundleIdentifier  // Current app identifier (replace with a variable as needed)
        
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching app version: ", error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let lookupResult = try JSONDecoder().decode(AppStoreResponse.self, from: data)
                guard let appInfo = lookupResult.results.first else {
                    completion(nil)
                    return
                }
                
                let newVersion = appInfo.version
                let releaseNotes = appInfo.releaseNotes
                
                    // Determine update type
                let updateType = self.checkVersionUpdate(currentVersion: currentVersion, newVersion: newVersion)
                
                let updateInfo = UpdateInfo(
                    updateType: updateType,
                    appName: self.appName,
                    newVersion: newVersion,
                    currentVersion: currentVersion,
                    releaseNotes: releaseNotes,
                    appURL: appInfo.trackViewUrl
                )
                
                completion(updateInfo)
            } catch {
                print("Error decoding JSON: ", error)
                completion(nil)
            }
        }
        
        task.resume()
    }
    
        // MARK: - Check if the update is major
        /// Checks if the update is a major update.
    private func checkVersionUpdate(currentVersion: String, newVersion: String) -> VersionUpdateType {
            // Split the version strings into components
        let currentComponents = currentVersion.split(separator: ".").compactMap { Int($0) }
        let newComponents = newVersion.split(separator: ".").compactMap { Int($0) }
        
            // Ensure both versions have at least a major version number
        guard !currentComponents.isEmpty, !newComponents.isEmpty else {
            return .none  // Invalid version format
        }
        
            // Compare major, minor, and patch version numbers
        if newComponents[0] > currentComponents[0] {
            return .major  // It's a major update
        } else if newComponents[0] == currentComponents[0] && newComponents.count > 1 && currentComponents.count > 1 {
            if newComponents[1] > currentComponents[1] {
                return .minor  // It's a minor update
            } else if newComponents[1] == currentComponents[1] && newComponents.count > 2 && currentComponents.count > 2 {
                if newComponents[2] > currentComponents[2] {
                    return .patch  // It's a patch update
                }
            }
        }
        
        return .none  // No update
    }
}
