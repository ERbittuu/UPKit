//
//  NotificationHandler.swift
//
//
//  Created by Utsav Patel on 09/09/2024.
//

import Foundation

public class NotificationHandler {
    
    // Run the closure on the main thread
    @discardableResult public static func when(_ event: Notification.Name,
                                               do closure: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: event, object: nil, queue: nil) { note in
            DispatchQueue.main.async {
                closure(note)
            }
        }
    }

    // Run the closure for a specific sender on the main thread
    @discardableResult public static func when(_ sender: Any, does event: Notification.Name,
                                               do closure: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: event, object: sender, queue: nil) { note in
            DispatchQueue.main.async {
                closure(note)
            }
        }
    }

    // Post an event
    public static func trigger(_ event: Notification.Name, on object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(Notification(name: event, object: object, userInfo: userInfo))
    }
}
