//
//  StoryboardIdentifiable.swift
//  
//
//  Created by Utsav Patel on 05/09/2024.
//

import UIKit

public protocol StoryboardIdentifiable {
    /// The identifier for the view controller in the storyboard.
    static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardIdentifiable {
    /// Conforms to `StoryboardIdentifiable` protocol by providing the view controller's class name as the identifier.
    public static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
