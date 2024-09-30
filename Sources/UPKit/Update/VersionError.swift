//
//  VersionError.swift
//  UPKit
//
//  Created by Utsav Patel on 01/10/2024.
//

import Foundation

    // MARK: - Enum for Errors
    /// Enum representing potential errors during version checking.
public enum VersionError: Error {
    case invalidResponse  // Indicates an invalid response from the App Store.
    case dataError        // Indicates an error with the data received.
}
