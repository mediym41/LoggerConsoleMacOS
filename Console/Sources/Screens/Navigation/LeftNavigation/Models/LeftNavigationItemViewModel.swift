//
//  LeftNavigationViewItem.swift
//  Console
//
//  Created by Дмитрий Пащенко on 04.11.2021.
//

import Combine

enum NavigationItemID: Int, Identifiable {
    case console
    case settings
    
    var id: RawValue { rawValue }
}

class LeftNavigationItemViewModel: ObservableObject, Identifiable {
    static func == (lhs: LeftNavigationItemViewModel, rhs: LeftNavigationItemViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    @Published var id: NavigationItemID
    @Published var isSelected: Bool
    
    var icon: String
    
    init(id: NavigationItemID, icon: String, isSelected: Bool) {
        self.id = id
        self.icon = icon
        self.isSelected = isSelected
    }
}
