//
//  LeftNavigationView.swift
//  Console
//
//  Created by Дмитрий Пащенко on 04.11.2021.
//

import SwiftUI
import Combine

class NavigationLeftViewItem {
    
}

struct LeftNavigationView: View {
    
    @ObservedObject var viewModel: LeftNavigationViewModel = .init()
    var consoleView: ConsoleView = .init()
    var settingsView: SettingsView = .init()
    
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                ForEach($viewModel.items) { $item in
                    Toggle(isOn: $item.isSelected, label: {
                        VStack {
                            Image(systemName: item.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .foregroundColor(item.isSelected ? Palette.TabBar.selectedIcon : Palette.TabBar.unselectedIcon)
                        }
                        .padding(10)
                        .background(item.isSelected ? Palette.TabBar.selectedButtonBackground : Palette.TabBar.unselectedButtonBackground)
                        .contentShape(Rectangle())
                    })
                    .toggleStyle(CheckToggleStyle())
                    .cornerRadius(5)
                    .allowsHitTesting(!item.isSelected)
                    .onChange(of: item.isSelected, perform: { isSelected in
                        if isSelected {
                            viewModel.updateSelection(id: item.id)
                        }
                    })
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.top, 10)
            .background(Palette.TabBar.background)
            
            VStack {
                switch (viewModel.selectedItem.id) {
                case .console:
                    consoleView
                case .settings:
                    settingsView
                }
                
            }
        }
    }
}
