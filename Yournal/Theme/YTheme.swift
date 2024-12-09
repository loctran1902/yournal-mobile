import SwiftUI

enum YTheme {
    case light
    case dark
    
    var background: Color {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }
    
    var text: Color {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    var secondaryText: Color {
        switch self {
        case .light:
            return .gray
        case .dark:
            return .gray
        }
    }
} 