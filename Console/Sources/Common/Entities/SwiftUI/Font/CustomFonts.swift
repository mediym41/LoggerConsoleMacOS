//
//  CustomFonts.swift
//  Console
//
//  Created by Дмитрий Пащенко on 03.11.2021.
//

import SwiftUI

extension Font {
    
    enum WeightKind {
        case ultraLight
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
    }
    
    static func circe(_ weight: WeightKind, size: CGFloat) -> Font {
        var fontName: String = "Circe-"
        switch weight {
        case .ultraLight:
            fontName += "Thin"
        case  .thin:
            fontName += "ExtraLight"
        case .light:
            fontName += "Light"
        case .regular:
            fontName += "Regular"
        case .medium, .semibold, .bold:
            fontName += "Bold"
        case .heavy:
            fontName += "ExtraBold"
        }
        
        return Font.custom(fontName, size: size)
    }
    
    static func museoCyrl(_ weight: WeightKind, size: CGFloat) -> Font {
        var fontName: String = "MuseoCyrl-"
        switch weight {
        case .ultraLight, .thin, .light:
            fontName += "100"
        case .regular:
            fontName += "300"
        case .medium, .semibold:
            fontName += "500"
        case .bold:
            fontName += "700"
        case .heavy:
            fontName += "900"
        }

        return Font.custom(fontName, size: size)
    }
    static func listInstalledFonts() {
        let fontFamilies = NSFontManager.shared.availableFontFamilies.sorted()
        for family in fontFamilies {
            print(family)
            let familyFonts = NSFontManager.shared.availableMembers(ofFontFamily: family)
            if let fonts = familyFonts {
                for font in fonts {
                  print("\t\(font)")
                }
            }
        }
    }
}
