//
//  UserDefault.swift
//  Console
//
//  Created by Дмитрий Пащенко on 07.11.2021.
//

import Foundation

public protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension String: PropertyListValue {}
extension Date: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}

// Every element must be a property-list type
extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}

@propertyWrapper
public class UserDefault<Value: PropertyListValue> {

    public let key: String
    public let defaultValue: Value

    private var storage: UserDefaults {
        return .standard
    }
    
    public var projectedValue: UserDefault { return self }

    public init(_ key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public init<Key: RawRepresentable>(_ key: Key, defaultValue: Value) where Key.RawValue == String {
        self.key = key.rawValue
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value {
        get {
            return storage.value(forKey: key) as? Value ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
    
    public func clear() {
        storage.removeObject(forKey: key)
    }
}
