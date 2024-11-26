//
//  AnimatorHelper.swift
//  JNGLBK
//
//  Created by Utsav Patel on 25/11/2024.
//

import UIKit

/// A utility class for performing animations.
public class AnimatorHelper {
    
    // MARK: - Collection View Animations
    
    /// Animates a collection view's initial appearance.
    /// - Parameters:
    ///   - collectionView: The collection view to animate.
    ///   - duration: The duration of the animation. Default is 0.6 seconds.
    ///   - delay: The delay before starting the animation. Default is 0.2 seconds.
    public static func animateCollectionViewAppearance(_ collectionView: UICollectionView, duration: TimeInterval = 0.6, delay: TimeInterval = 0.2) {
        collectionView.alpha = 0.0
        collectionView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut], animations: {
            collectionView.alpha = 1.0
            collectionView.transform = .identity
        })
    }
    
    /// Animates individual collection view cells as they appear.
    /// - Parameters:
    ///   - cell: The cell to animate.
    ///   - indexPath: The index path of the cell.
    ///   - duration: The duration of the animation. Default is 0.8 seconds.
    ///   - delayMultiplier: The multiplier for the animation delay based on the cell's position. Default is 0.05.
    public static func animateCell(_ cell: UICollectionViewCell, at indexPath: IndexPath, duration: TimeInterval = 0.8, delayMultiplier: Double = 0.05) {
        let delay = Double(indexPath.row) * delayMultiplier
        cell.alpha = 0.0
        cell.transform = CGAffineTransform(translationX: 0, y: 100)
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: [],
            animations: {
                cell.alpha = 1.0
                cell.transform = .identity
            }
        )
    }
    
    /// Handles animations during device orientation changes.
    /// - Parameters:
    ///   - collectionView: The collection view to animate.
    ///   - coordinator: The transition coordinator handling the orientation change.
    public static func animateOrientationChange(_ collectionView: UICollectionView, coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            UIView.animate(
                withDuration: context.transitionDuration,
                animations: {
                    collectionView.transform = CGAffineTransform(rotationAngle: .pi / 8).scaledBy(x: 0.8, y: 0.8)
                    collectionView.alpha = 0.0
                }
            )
        }, completion: { context in
            collectionView.reloadData()
            UIView.animate(
                withDuration: context.transitionDuration,
                animations: {
                    collectionView.transform = .identity
                    collectionView.alpha = 1.0
                }
            )
        })
    }
    
    // MARK: - Generic View Animations
    
    /// Animates a view with fade-in and scale effects.
    /// - Parameters:
    ///   - view: The view to animate.
    ///   - duration: The duration of the animation. Default is 0.6 seconds.
    ///   - delay: The delay before starting the animation. Default is 0.2 seconds.
    public static func fadeInAndScale(_ view: UIView, duration: TimeInterval = 0.6, delay: TimeInterval = 0.2) {
        view.alpha = 0.0
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut], animations: {
            view.alpha = 1.0
            view.transform = .identity
        })
    }
    
    /// Animates a view with rotation and scaling effects.
    /// - Parameters:
    ///   - view: The view to animate.
    ///   - angle: The angle of rotation in radians. Default is π/8.
    ///   - scale: The scale factor. Default is 0.8.
    ///   - duration: The duration of the animation. Default is 0.6 seconds.
    public static func rotateAndScale(_ view: UIView, angle: CGFloat = .pi / 8, scale: CGFloat = 0.8, duration: TimeInterval = 0.6) {
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform(rotationAngle: angle).scaledBy(x: scale, y: scale)
        }
    }
    
    // MARK: - Window Root View Controller Transition
    
    /// Replaces the root view controller of the window with an animation.
    /// - Parameters:
    ///   - window: The window whose root view controller will be replaced.
    ///   - newViewController: The new view controller to set as root.
    ///   - animated: Whether to animate the transition. Default is `true`.
    ///   - duration: The duration of the transition animation. Default is 1.0 seconds.
    ///   - completion: A completion handler called after the transition.
    public static func replaceRootViewController(in window: UIWindow,
                                                 with newViewController: UIViewController,
                                                 animated: Bool = true,
                                                 duration: TimeInterval = 1.0,
                                                 completion: (() -> Void)? = nil) {
        guard animated else {
            window.rootViewController = newViewController
            window.makeKeyAndVisible()
            completion?()
            return
        }
        
        UIView.transition(
            with: window,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = newViewController
                UIView.setAnimationsEnabled(oldState)
            },
            completion: { _ in
                window.makeKeyAndVisible()
                completion?()
            }
        )
    }
    
    public static func animateCellSelectionBegin(on cell: UICollectionViewCell?, scale: CGFloat = 0.95, duration: TimeInterval = 0.1) {
        guard let cell = cell else { return }
        
        UIView.animate(withDuration: duration, animations: {
            cell.alpha = 0.5
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        })
    }
    
    public static func animateCellSelectionEnd(on cell: UICollectionViewCell?, duration: TimeInterval = 0.1, completion: (() -> Void)? = nil) {
        guard let cell = cell else { return }
        
        UIView.animate(withDuration: duration, animations: {
            cell.alpha = 1
            cell.transform = .identity
        }) { _ in
            completion?()
        }
    }
}
