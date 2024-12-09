import SwiftUI

enum YButtonStyle {
    case primary
    case secondary
    case text
    
    func backgroundColor(for theme: YTheme) -> Color {
        switch self {
        case .primary:
            return .orange
        case .secondary:
            return theme == .dark ? .gray.opacity(0.2) : .gray.opacity(0.1)
        case .text:
            return .clear
        }
    }
    
    func foregroundColor(for theme: YTheme) -> Color {
        switch self {
        case .primary:
            return theme == .dark ? .black : .white
        case .secondary:
            return theme.text
        case .text:
            return theme.text
        }
    }
    
    var padding: EdgeInsets {
        switch self {
        case .primary, .secondary:
            return EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        case .text:
            return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        }
    }
}
