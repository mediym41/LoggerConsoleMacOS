//
//  LeftNavigationViewModel.swift
//  Console
//
//  Created by Дмитрий Пащенко on 04.11.2021.
//

import Foundation

class LeftNavigationViewModel: ObservableObject {
    static func == (lhs: LeftNavigationViewModel, rhs: LeftNavigationViewModel) -> Bool {
        return true
    }
    
    @Published var items: [LeftNavigationItemViewModel]
    
    var selectedItem: LeftNavigationItemViewModel {
        guard let selected = items.first(where: { $0.isSelected }) else {
            fatalError("Unexpected behaviod")
        }
        
        return selected
    }
    
    func updateSelection(id: NavigationItemID) {
        objectWillChange.send()
        items.forEach({ $0.isSelected = id == $0.id })
    }
    
    init(items: [LeftNavigationItemViewModel] = [
        .init(id: .console, icon: "trash", isSelected: true),
        .init(id: .settings, icon: "gear", isSelected: false)
    ]) {
        self.items = items
    }
}
