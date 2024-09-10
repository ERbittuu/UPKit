//
//  File.swift
//  
//
//  Created by Utsav Patel on 09/09/2024.
//

import Foundation

extension Bundle {
    public var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    public var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    public var name: String {
        return infoDictionary?["CFBundleName"] as? String ?? "Drawing Pad"
    }
}
