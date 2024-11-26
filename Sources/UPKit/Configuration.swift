//
//  Configuration.swift
//  UPKit
//
//  Created by Utsav Patel on 22/11/2024.
//

import Foundation

public class Configuration {

    private static let info = Bundle.main.infoDictionary
    
    public static var displayName: String {
        return Configuration.info?["CFBundleDisplayName"] as? String
        ?? Configuration.info?[kCFBundleNameKey as String] as? String ?? "Unknown"
    }
    
    public static var version: String {
        return Configuration.info?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    public static var buildNumber: String {
        return Configuration.info?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    public static var isDebugMode: Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }
}
