//
//  AppStoreResponse.swift
//  UPKit
//
//  Created by Utsav Patel on 01/10/2024.
//

import Foundation

    // MARK: - AppStore Response Structures
struct AppStoreResponse: Codable {
    let resultCount: Int                   // Number of results returned.
    let results: [AppStoreApp]             // List of app information results.
}
