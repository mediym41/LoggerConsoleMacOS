//
//  JsonCollapsableViewModels.swift
//  Console
//
//  Created by Дмитрий Пащенко on 07.11.2021.
//

import Foundation

final class CollapseItemViewModel: Identifiable {
    let id: UUID
    let source: JsonCollapsableItem?
    
    var isCollapsable: Bool {
        return source != nil
    }
    
    var isExpanded: Bool {
        return source?.isExpanded ?? true
    }
    
    init(source: JsonCollapsableItem?) {
        self.id = .init()
        self.source = source
    }
}

// MARK: - JSON
final class JsonValueItemViewModel {
    var id: UUID
    var value: String
    
    init(json: JsonValue) {
        self.id = .init()
        
        switch json {
        case .integer(let integer):
            self.value = String(integer)
        case .double(let double):
            self.value = String(double)
        case .string(let string):
            self.value = "\"\(string)\""
        case .bool(let bool):
            self.value = String(bool)
        case .none:
            self.value = "null"
        }
    }
}

protocol JsonCollapsableItem: AnyObject {
    var isExpanded: Bool { get set }
}

final class JsonDictionaryItemViewModel: JsonCollapsableItem {
    var id: UUID
    var state: [String: JsonItemViewModel]
    var isExpanded: Bool
    
    init(json: [String: JsonRepresentable]) {
        self.id = .init()
        self.state = json.mapValues({ .init(json: $0) })
        self.isExpanded = true
    }
}

final class JsonArrayItemViewModel: JsonCollapsableItem {
    var id: UUID
    var state: [JsonItemViewModel]
    var isExpanded: Bool
    
    init(json: [JsonRepresentable]) {
        self.id = .init()
        self.state = json.map({ .init(json: $0) })
        self.isExpanded = true
    }
}

enum JsonContainerViewModel {
    case dictionary(JsonDictionaryItemViewModel)
    case array(JsonArrayItemViewModel)
    
    var jsonCollapsableItem: JsonCollapsableItem {
        switch self {
        case .dictionary(let jsonDictionaryItemViewModel):
            return jsonDictionaryItemViewModel
        case .array(let jsonArrayItemViewModel):
            return jsonArrayItemViewModel
        }
    }
    
    init(json: JsonContainer) {
        switch json {
        case .dictionary(let dictionary):
            self = .dictionary(.init(json: dictionary))
        case .array(let array):
            self = .array(.init(json: array))
        }
    }
}

enum JsonItemViewModel {
    case container(JsonContainerViewModel)
    case value(JsonValueItemViewModel)
    
    var jsonCollapsableItem: JsonCollapsableItem? {
        switch self {
        case .container(let jsonContainerViewModel):
            return jsonContainerViewModel.jsonCollapsableItem
        case .value:
            return nil
        }
    }
    
    init(json: JsonRepresentable) {
        switch json {
        case .container(let jsonContainer):
            self = .container(.init(json: jsonContainer))
        case .value(let jsonValue):
            self = .value(.init(json: jsonValue))
        }
    }
}
