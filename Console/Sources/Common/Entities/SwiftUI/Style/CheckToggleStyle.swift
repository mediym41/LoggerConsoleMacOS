//
//  CheckToggleStyle.swift
//  Console
//
//  Created by Дмитрий Пащенко on 04.11.2021.
//

import SwiftUI

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
        }
        .buttonStyle(PlainButtonStyle())
    }
}
