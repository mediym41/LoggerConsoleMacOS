//
//  ConsoleViewItem.swift
//  Console
//
//  Created by Дмитрий Пащенко on 07.11.2021.
//

import SwiftUI

final class ConsoleViewItem: Identifiable {
    var id: UUID
    var title: String
    var message: JsonItemViewModel?
    var jsonFormattedMessage: String?
    var collapseItems: [CollapseItemViewModel]
    var markers: [String]
    var date: Date
    var logLevel: LogLevelKind
    var isExpanded: Bool
    
    var color: Color { logLevel.color }
    
    var dateString: String {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    init(id: UUID = .init(), title: String, message: JsonItemViewModel? = nil, markers: [String], date: Date = .init(), logLevel: LogLevelKind, isExpanded: Bool) {
        self.id = id
        self.title = title
        self.message = message
        self.markers = markers
        self.date = date
        self.logLevel = logLevel
        self.isExpanded = isExpanded
        self.jsonFormattedMessage = nil
        self.collapseItems = []
        
        recalculateJson()
    }
    
    func recalculateJson() {
        if let message = message {
            let jsonViewModelBuilder: JsonViewModelBuilder = .init()
            jsonViewModelBuilder.build(json: message, spacing: 4)
            self.jsonFormattedMessage = jsonViewModelBuilder.formattedJsonString
            self.collapseItems = jsonViewModelBuilder.collapsableItems
        } else {
            self.jsonFormattedMessage = nil
            self.collapseItems = []
        }
    }
}

// MARK: - Hashable
extension ConsoleViewItem: Hashable {
    static func == (lhs: ConsoleViewItem, rhs: ConsoleViewItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(markers)
        hasher.combine(date)
        hasher.combine(logLevel)
    }
}
