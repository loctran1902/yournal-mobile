import SwiftUI

struct YButton: View {
    let title: String
    let style: YButtonStyle
    let icon: String?
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isPressed = false
    
    init(
        title: String,
        style: YButtonStyle = .primary,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.icon = icon
        self.action = action
    }
    
    private var theme: YTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(style.foregroundColor(for: theme))
            .frame(maxWidth: style == .text ? nil : .infinity)
            .padding(style.padding)
            .background(style.backgroundColor(for: theme))
            .cornerRadius(style == .text ? 8 : 30)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        isPressed = false
                    }
                }
        )
    }
}

#Preview {
    Group {
        VStack(spacing: 20) {
            YButton(title: "Primary Button", style: .primary) {}
            YButton(title: "Secondary Button", style: .secondary) {}
            YButton(title: "Text Button", style: .text) {}
            YButton(title: "With Icon", icon: "plus") {}
        }
        .padding()
        .background(Color.black)
        .environment(\.colorScheme, .dark)
        
        VStack(spacing: 20) {
            YButton(title: "Primary Button", style: .primary) {}
            YButton(title: "Secondary Button", style: .secondary) {}
            YButton(title: "Text Button", style: .text) {}
            YButton(title: "With Icon", icon: "plus") {}
        }
        .padding()
        .background(Color.white)
        .environment(\.colorScheme, .light)
    }
}
