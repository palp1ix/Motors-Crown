//
//  Theme.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/26/25.
//

import SwiftUI

enum Theme {
    /// Фоновый цвет - очень светлый, холодный серый. Создает ощущение чистоты и пространства.
    static let background = Color(hex: "EFF0F3")
    
    /// Цвет поверхностей (карточки, и т.д.) - абсолютно белый для максимального контраста.
    static let surface = Color(hex: "FFFFFF")
    
    /// Акцентный цвет - глубокий, статусный синий. Ассоциируется с надежностью и премиальностью.
    static let primaryAccent = Color(hex: "0A3D62")
    
    /// Основной текст - темный графитовый цвет. Читается лучше, чем чисто черный, и выглядит мягче.
    static let primaryText = Color(hex: "1A202C")

    /// Второстепенный текст - приглушенный серый, который хорошо сочетается с основным.
    static let secondaryText = Color(hex: "6D727A")
    
    /// Иконки на акцентном фоне - белый для наилучшей читаемости.
    static let icon = Color.white
    
    /// Звезды рейтинга теперь тоже в акцентном цвете для стилистического единства.
    static let star = Color(hex: "0A3D62")
}


// Расширение Color остается без изменений
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r, g, b, a: Double
        switch hex.count {
        case 6: // RRGGBB
            r = Double((rgb >> 16) & 0xFF) / 255
            g = Double((rgb >> 8) & 0xFF) / 255
            b = Double(rgb & 0xFF) / 255
            a = 1.0
        case 8: // RRGGBBAA
            r = Double((rgb >> 24) & 0xFF) / 255
            g = Double((rgb >> 16) & 0xFF) / 255
            b = Double((rgb >> 8) & 0xFF) / 255
            a = Double(rgb & 0xFF) / 255
        default:
            r = 0; g = 0; b = 0; a = 1
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
