//
//  Storyboard.swift
//
//
//  Created by Utsav Patel on 05/09/2024.
//

import UIKit

/// Represents a storyboard with a raw value.
public struct Storyboard: Hashable, Equatable, RawRepresentable {
    /// The raw value of the storyboard, typically the name of the storyboard file.
    public var rawValue: String
    
    /// Initializes a `Storyboard` with a raw value.
    ///
    /// - Parameter rawValue: The raw value representing the storyboard name.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    /// Conforms to `Equatable` protocol.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Storyboard` to compare.
    ///   - rhs: The right-hand side `Storyboard` to compare.
    /// - Returns: `true` if both `Storyboard` instances have the same raw value.
    public static func == (lhs: Storyboard, rhs: Storyboard) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    /// Conforms to `Hashable` protocol.
    ///
    /// - Parameter hasher: The hasher to use for combining the raw value.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
    /// Returns the filename of the storyboard.
    public var filename: String {
        return self.rawValue
    }
}

public extension UIStoryboard {
    /// Initializes a storyboard with a `Storyboard` instance.
    ///
    /// - Parameters:
    ///   - storyboard: The `Storyboard` instance representing the storyboard to load.
    ///   - bundle: An optional `Bundle` where the storyboard file is located. If `nil`, the main bundle is used.
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }

    /// Returns an instance of `UIStoryboard` for the specified `Storyboard`.
    ///
    /// - Parameters:
    ///   - storyboard: The `Storyboard` instance representing the storyboard to load.
    ///   - bundle: An optional `Bundle` where the storyboard file is located. If `nil`, the main bundle is used.
    /// - Returns: An instance of `UIStoryboard`.
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }

    /// Instantiates a view controller of type `T` from the storyboard.
    ///
    /// - Returns: An instance of the view controller type `T`.
    /// - Throws: A `fatalError` if the view controller cannot be instantiated.
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier)")
        }
        return viewController
    }
}
