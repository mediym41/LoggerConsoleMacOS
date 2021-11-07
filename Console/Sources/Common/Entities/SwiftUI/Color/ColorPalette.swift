//
//  ColorPalette.swift
//  Console
//
//  Created by Дмитрий Пащенко on 04.11.2021.
//

import SwiftUI

public struct Palette {
    public static let tabBar: Color = .init(nsColor: #colorLiteral(red: 0.01427771617, green: 0.1119213179, blue: 0.1739414632, alpha: 1))
    public static let main: Color = .init(nsColor: #colorLiteral(red: 0.05098039216, green: 0.1294117647, blue: 0.1921568627, alpha: 1))
    public static let buttonSelection: Color = .init(nsColor: #colorLiteral(red: 0.1433842182, green: 0.3057968318, blue: 0.4051813483, alpha: 1))
    public static let frame: Color = .init(nsColor: #colorLiteral(red: 0.06140743941, green: 0.1831198931, blue: 0.253436029, alpha: 1))
    public static let icons: Color = .init(nsColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    
    public static let tabSelection: Color = .init(nsColor: #colorLiteral(red: 0.06098075211, green: 0.1950971186, blue: 0.2778621018, alpha: 1))
    
    public struct Text {
        public static let white: Color = .init(nsColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        public static let green: Color = .init(nsColor: #colorLiteral(red: 0.05542809516, green: 0.7046283484, blue: 0.5300347209, alpha: 1))
        public static let blue: Color = .init(nsColor: #colorLiteral(red: 0.2351574004, green: 0.7992752194, blue: 0.8699329495, alpha: 1))
        public static let yellow: Color = .init(nsColor: #colorLiteral(red: 0.9962943196, green: 0.7961905003, blue: 0.2514524758, alpha: 1))
        public static let red: Color = .init(nsColor: #colorLiteral(red: 0.9648080468, green: 0.1208269075, blue: 0.2692105174, alpha: 1))
    }
    
    public struct TabBar {
        public static let background: Color = .init(nsColor: #colorLiteral(red: 0.01427771617, green: 0.1119213179, blue: 0.1739414632, alpha: 1))
        public static let selectedButtonBackground: Color = .init(nsColor: #colorLiteral(red: 0.06098075211, green: 0.1950971186, blue: 0.2778621018, alpha: 1))
        public static let unselectedButtonBackground: Color = .clear
        public static let selectedIcon: Color = .init(nsColor: #colorLiteral(red: 0.7829751372, green: 0.8329711556, blue: 0.866453588, alpha: 1))
        public static let unselectedIcon: Color = .init(nsColor: #colorLiteral(red: 0.3014722466, green: 0.46309793, blue: 0.5500337481, alpha: 1))
    }
    
    public struct Row {
        public static var darkBackground: Color = .clear
        public static var lightBackground: Color = .init(nsColor: #colorLiteral(red: 0.055368662, green: 0.1419126668, blue: 0.2145432366, alpha: 1))
        public static var markerBackground: Color = .init(nsColor: #colorLiteral(red: 0.06098075211, green: 0.1950971186, blue: 0.2778621018, alpha: 1))
        public static var marker: Color = .init(nsColor: #colorLiteral(red: 0.01427771617, green: 0.1119213179, blue: 0.1739414632, alpha: 1))
        public static var title: Color = .init(nsColor: #colorLiteral(red: 0.337254902, green: 0.4039215686, blue: 0.4549019608, alpha: 1))
        public static var subtitle: Color = .init(nsColor: #colorLiteral(red: 0.631372549, green: 0.6745098039, blue: 0.7019607843, alpha: 1))
    }
    
    public struct TextInput {
        public static var background: Color = .init(nsColor: #colorLiteral(red: 0.05098039216, green: 0.1294117647, blue: 0.1921568627, alpha: 1))
    }
    
    public struct Container {
        public static var common: Color = .init(nsColor: #colorLiteral(red: 0.06140743941, green: 0.1831198931, blue: 0.253436029, alpha: 1))
        public static var nested: Color = .init(nsColor: #colorLiteral(red: 0.08236495607, green: 0.2491340034, blue: 0.3500510633, alpha: 1))
    }
}
