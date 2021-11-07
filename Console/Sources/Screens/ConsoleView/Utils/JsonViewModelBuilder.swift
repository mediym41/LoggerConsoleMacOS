//
//  JsonViewModelBuilder.swift
//  Console
//
//  Created by Дмитрий Пащенко on 07.11.2021.
//

import Foundation

class JsonViewModelBuilder {
    
    var collapsableItems: [CollapseItemViewModel] = []
    var formattedJsonString: String = ""
    
    func build(json: JsonItemViewModel, spacing: Int) {
        collapsableItems.removeAll()
        formattedJsonString.removeAll()
        
        collapsableItems.append(.init(source: json.jsonCollapsableItem))
        formattedJsonString = encodeJson(item: json, level: 0, spacing: spacing)
    }
    
    private func generateOffset(level: Int, size: Int) -> String {
        return String(repeating: " ", count: level * size)
    }
    
    private func encodeJson(item: JsonItemViewModel, level: Int = 0, spacing: Int) -> String {
        switch item {
        case .container(let container):
            return encodeJson(container: container, level: level, spacing: spacing)
        case .value(let value):
            return encodeJson(value: value)
        }
    }
    
    func encodeJson(container: JsonContainerViewModel, level: Int, spacing: Int) -> String {
        switch container {
        case .dictionary(let dictionary):
            return encodeJson(dictionary: dictionary, level: level, spacing: spacing)
        case .array(let array):
            return encodeJson(array: array, level: level, spacing: spacing)
        }
    }
    
    func encodeJson(dictionary item: JsonDictionaryItemViewModel, level: Int, spacing: Int) -> String {
        guard !item.state.isEmpty else {
            return "{}"
        }
        
        if item.isExpanded {
            let currentOffset = generateOffset(level: level, size: spacing)
            let nextOffset = generateOffset(level: level + 1, size: spacing)
            
            var rows: [String] = []
                        
            for (key, value) in item.state {
                switch value {
                case .container(let containerItem):
                    // add
                    collapsableItems.append(.init(source: containerItem.jsonCollapsableItem))
                    rows.append("\(nextOffset)\"\(key)\": \(encodeJson(container: containerItem, level: level + 1, spacing: spacing))")
                case .value(let valueItem):
                    collapsableItems.append(.init(source: nil))
                    rows.append("\(nextOffset)\"\(key)\": \(encodeJson(value: valueItem))")
                }
            }

            collapsableItems.append(.init(source: nil))
            return ["{", rows.joined(separator: ",\n"), "\(currentOffset)}"].joined(separator: "\n")
            
        } else {
            return "{ *** }"
        }
    }
    
    func encodeJson(array: JsonArrayItemViewModel, level: Int, spacing: Int) -> String {
        if array.isExpanded {
            guard !array.state.isEmpty else {
                return "[]"
            }
            
            let currentOffset = generateOffset(level: level, size: spacing)
            let nextOffset = generateOffset(level: level + 1, size: spacing)
            
            var result: String = "["
            
            for index in 0 ..< array.state.count {
                switch array.state[index] {
                case .container(let containerItem): // add
                    collapsableItems.append(.init(source: containerItem.jsonCollapsableItem))
                    result += "\n\(nextOffset)\(encodeJson(container: containerItem, level: level + 1, spacing: spacing))"
                case .value(let valueItem):
                    result += encodeJson(value: valueItem)
                }
                
                // is last index?
                if index < array.state.count - 1 {
                    result += ", "
                }
            }
            
            if case .container = array.state[array.state.count - 1] {
                collapsableItems.append(.init(source: nil))
                result += "\n\(currentOffset)]"
            } else {
                result += "]"
            }
            
            return result
            
        } else {
            return "[ *** ]"
        }
    }
    
    func encodeJson(value item: JsonValueItemViewModel) -> String {
        return item.value
    }
    
}
