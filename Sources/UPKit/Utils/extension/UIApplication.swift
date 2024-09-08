//
//  UIApplication.swift
//
//
//  Created by Utsav Patel on 07/09/2024.
//

import UIKit

public extension UIApplication {
    /// Retrieves the topmost view controller in the current view controller hierarchy.
    public static var topViewController: UIViewController? {
        // Get the root view controller from the key window
        guard let base = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return nil
        }
        return getTopViewController(base: base)
    }
    
    /// Helper method to recursively find the topmost view controller starting from a base controller.
    private static func getTopViewController(base: UIViewController?) -> UIViewController? {
        // Use guard to safely unwrap the base view controller
        guard let base = base else { return nil }
        
        // Handle navigation controllers
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        
        // Handle tab bar controllers
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        }
        
        // Handle presented view controllers
        if let presented = base.presentedViewController {
            return getTopViewController(base: presented)
        }
        
        // If no further controllers are found, return the base view controller
        return base
    }
}
