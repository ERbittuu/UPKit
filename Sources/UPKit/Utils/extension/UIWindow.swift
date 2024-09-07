//
//  File.swift
//  
//
//  Created by Utsav Patel on 05/09/2024.
//
import UIKit

public extension UIWindow {
    
    /// Replaces the root view controller with a new view controller using a fade animation.
    /// - Parameters:
    ///   - newViewController: The new view controller to set as the root.
    ///   - duration: The duration of the fade animation. Default is 0.5 seconds.
    func replaceRootViewController(_ newViewController: UIViewController,
                                   duration: TimeInterval = 0.5) {
        // Set the new view controller as the root view controller
        rootViewController = newViewController
        makeKeyAndVisible()
        // Perform the fade animation with the specified duration
        UIView.transition(with: self,
                          duration: duration,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
    }
}
