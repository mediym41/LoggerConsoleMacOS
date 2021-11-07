//
//  LogLevelViewModels.swift
//  Console
//
//  Created by Дмитрий Пащенко on 07.11.2021.
//

import SwiftUI

enum LogLevelKind: Int {
    case all, debug, info, warning, error
    
    init(logLevel: LogLevel) {
        switch logLevel {
        case .debug:
            self = .debug
        case .info:
            self = .info
        case .warning:
            self = .warning
        case .error:
            self = .error
        }
    }
    
    var color: Color {
        switch self {
        case .all:
            return Palette.Text.white
        case .debug:
            return Palette.Text.green
        case .info:
            return Palette.Text.blue
        case .warning:
            return Palette.Text.yellow
        case .error:
            return Palette.Text.red
        }
    }
}


extension LogLevelKind: Identifiable {
    var id: RawValue { rawValue }
}

class LogLevelFilterToggleViewModel: ObservableObject, Identifiable {
    var id: LogLevelKind
    @Published var title: String
    @Published var isOn: Bool
    
    var color: Color { id.color }

    
    init(id: LogLevelKind, title: String, isOn: Bool) {
        self.id = id
        self.title = title
        self.isOn = isOn
    }
}
