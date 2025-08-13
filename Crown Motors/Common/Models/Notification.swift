import UIKit

struct Notification {
    let title: String
    let subtitle: String
    let symbol: String
    let body: String
    let color: UIColor
    
    // Main initializer
    init(title: String, subtitle: String, symbol: String, body: String, color: UIColor = .systemBlue) {
        self.title = title
        self.subtitle = subtitle
        self.symbol = symbol
        self.body = body
        self.color = color
    }
    
    // Convenience initializers for common notification types
    static func info(title: String, subtitle: String = "", body: String = "") -> Notification {
        return Notification(title: title, subtitle: subtitle, symbol: "info.circle.fill", body: body, color: .systemBlue)
    }
    
    static func success(title: String, subtitle: String = "", body: String = "") -> Notification {
        return Notification(title: title, subtitle: subtitle, symbol: "checkmark.circle.fill", body: body, color: .systemGreen)
    }
    
    static func warning(title: String, subtitle: String = "", body: String = "") -> Notification {
        return Notification(title: title, subtitle: subtitle, symbol: "exclamationmark.triangle.fill", body: body, color: .systemOrange)
    }
    
    static func error(title: String, subtitle: String = "", body: String = "") -> Notification {
        return Notification(title: title, subtitle: subtitle, symbol: "xmark.circle.fill", body: body, color: .systemRed)
    }
    
    static func custom(title: String, subtitle: String = "", symbol: String, body: String = "", color: UIColor = .systemBlue) -> Notification {
        return Notification(title: title, subtitle: subtitle, symbol: symbol, body: body, color: color)
    }
}
