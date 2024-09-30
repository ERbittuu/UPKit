//
//  UpdateInfo.swift
//  UPKit
//
//  Created by Utsav Patel on 01/10/2024.
//

import Foundation

    // MARK: - Update Information Structure
    /// Structure containing information about an app update.
public struct UpdateInfo {
    public let updateType: VersionUpdateType     // The type of update (minor, major, required).
    public let appName: String               // The name of the app.
    public let newVersion: String           // The new version available in the App Store.
    public let currentVersion: String         // The current version of the app.
    public let releaseNotes: String         // Release notes for the new version.
    public let appURL: String               // URL to the app in the App Store.
}
