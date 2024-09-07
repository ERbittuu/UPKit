//
//  UIViewControllerCreatable.swift
//  
//
//  Created by Utsav Patel on 05/09/2024.
//

import UIKit

public protocol UIViewControllerCreatable {}

public extension UIViewControllerCreatable where Self: UIViewController {
    /// Creates an instance of the view controller from the specified storyboard.
    ///
    /// - Parameter storyboard: The `Storyboard` instance representing the storyboard to load.
    /// - Returns: An instance of the view controller.
    static func create(from storyboard: Storyboard) -> Self {
        return UIStoryboard(storyboard: storyboard).instantiateViewController()
    }

    /// Dismisses the view controller.
    ///
    /// - Parameter completion: An optional closure to execute after the view controller is dismissed.
    func dismiss(completion: (() -> Void)? = nil) {
        self.dismiss(animated: true, completion: completion)
    }
}
