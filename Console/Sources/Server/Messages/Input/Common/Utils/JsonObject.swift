//
//  JsonObject.swift
//  Console
//
//  Created by Дмитрий Пащенко on 05.11.2021.
//

import Foundation

enum JsonRepresentable: Decodable, Identifiable, Hashable {
    static func == (lhs: JsonRepresentable, rhs: JsonRepresentable) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String {
        return String(describing: self)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case container(JsonContainer)
    case value(JsonValue)
    
    init(from decoder: Decoder) throws {
        if let container = try? JsonContainer(from: decoder) {
            self = .container(container)
        } else {
            self = .value(try JsonValue(from: decoder))
        }
    }
}



enum JsonValue: Decodable {
    case integer(Int)
    case double(Double)
    case string(String)
    case bool(Bool)
    case none
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self = .none
        } else if let integerValue = try? container.decode(Int.self) {
            self = .integer(integerValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else {
            let stringValue = try container.decode(String.self)
            self = .string(stringValue)
        }
    }
}

enum JsonContainer: Decodable, Identifiable {
    case dictionary([String: JsonRepresentable])
    case array([JsonRepresentable])

    var id: String {
        return String(describing: self)
    }
    
    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: FlexibleCodingKey.self) {
            var dictionaryValue: [String: JsonRepresentable] = [:]
            
            for key in container.allKeys {
                let jsonContainer = try container.decode(JsonRepresentable.self, forKey: key)
                dictionaryValue[key.stringValue] = jsonContainer
            }

            self = .dictionary(dictionaryValue)
            
        } else {
            var container = try decoder.unkeyedContainer()
            var arrayValue: [JsonRepresentable] = []
            
            while !container.isAtEnd {
                let value = try container.decode(JsonRepresentable.self)
                arrayValue.append(value)
            }
            
            self = .array(arrayValue)
        }
    }
}


