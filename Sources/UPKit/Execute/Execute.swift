//
//  Execute.swift
//
//
//  Created by Utsav Patel on 05/09/2024.
//

import Foundation

/// A utility class providing convenient methods for executing code on different threads.
public class Execute {

    /// Prevents initialization of this utility class.
    private init() {}

    /// Executes a closure asynchronously on a background thread.
    /// - Parameter task: The closure to execute.
    public static func inBackground(_ task: @escaping () -> Void) {
        DispatchQueue.global().async(execute: task)
    }

    /// Executes a closure asynchronously on the main thread after a specified delay.
    /// - Parameters:
    ///   - delay: The time interval, in seconds, to wait before executing the closure.
    ///   - task: The closure to execute after the delay.
    public static func afterDelay(of delay: Double, task: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
    }

    /// Executes a closure asynchronously on the main thread.
    /// - Parameter task: The closure to execute.
    public static func onMain(_ task: @escaping () -> Void) {
        DispatchQueue.main.async(execute: task)
    }
}
