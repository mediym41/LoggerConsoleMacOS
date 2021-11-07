//
//  MainApp.swift
//  Console
//
//  Created by Дмитрий Пащенко on 04.11.2021.
//

import SwiftUI

@main
struct TestProjectApp: App {
    var body: some Scene {
        WindowGroup {
            LeftNavigationView()
                .background(Palette.main)
                .also({
                    print("Test")
                    Server.shared.start()
                })
//            NavigationView {
//                Sidebar()
//                    .background(Palette.tabBar)
//            }
//            .background(Palette.main)
//            .foregroundColor(.green)
//            .padding(0)
            //#colorLiteral(red: 1, green: 1, blue: 0.9999999404, alpha: 1)
        }.windowStyle(HiddenTitleBarWindowStyle())
    }
}


extension View {
    func also(_ completion: () -> Void) -> Self {
        completion()
        return self
    }
}


