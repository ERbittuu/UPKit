//
//  Default.swift
//  UPKit
//
//  Created by Utsav Patel on 22/11/2024.
//
import Foundation

@propertyWrapper
public struct Default<Value> {
    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults
    
    public init(wrappedValue: Value, key: String, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = wrappedValue
        self.storage = storage
    }
    
    public var wrappedValue: Value {
        get {
            return storage.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
    
    public mutating func reset() {
        wrappedValue = defaultValue
    }
}
