import SwiftUI

enum DesignSystemSection: String, CaseIterable {
    case typography = "Typography"
    case colors = "Colors"
    case buttons = "Buttons"
    case inputs = "Inputs"
    case spacing = "Spacing"
}

struct DesignSystemView: View {
    @State private var selectedSection: DesignSystemSection = .typography
    @Namespace private var namespace
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Section Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(DesignSystemSection.allCases, id: \.self) { section in
                            VStack {
                                Text(section.rawValue)
                                    .font(.headline)
                                    .foregroundColor(selectedSection == section ? .primary : .secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                
                                if selectedSection == section {
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.orange)
                                        .matchedGeometryEffect(id: "underline", in: namespace)
                                } else {
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.clear)
                                }
                            }
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selectedSection = section
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color(UIColor.systemBackground))
                
                // Content
                ScrollView {
                    VStack(spacing: 32) {
                        switch selectedSection {
                        case .typography:
                            TypographySection()
                        case .colors:
                            ColorsSection()
                        case .buttons:
                            ButtonsSection()
                        case .inputs:
                            InputsSection()
                        case .spacing:
                            SpacingSection()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Design System")
        }
    }
}

struct TypographySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionTitle("Typography")
            
            Group {
                TextStyleRow(name: "Large Title", font: .largeTitle)
                TextStyleRow(name: "Title", font: .title)
                TextStyleRow(name: "Title 2", font: .title2)
                TextStyleRow(name: "Title 3", font: .title3)
                TextStyleRow(name: "Headline", font: .headline)
                TextStyleRow(name: "Body", font: .body)
                TextStyleRow(name: "Callout", font: .callout)
                TextStyleRow(name: "Subheadline", font: .subheadline)
                TextStyleRow(name: "Footnote", font: .footnote)
                TextStyleRow(name: "Caption", font: .caption)
            }
        }
    }
}

struct ColorsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionTitle("Colors")
            
            Group {
                ColorRow(name: "Primary", color: .orange)
                ColorRow(name: "Background (Dark)", color: .black)
                ColorRow(name: "Background (Light)", color: .white)
                ColorRow(name: "Text Primary (Dark)", color: .white)
                ColorRow(name: "Text Primary (Light)", color: .black)
                ColorRow(name: "Text Secondary", color: .gray)
            }
        }
    }
}

struct ButtonsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionTitle("Buttons")
            
            Group {
                ButtonRow(title: "Primary Button", style: .primary)
                ButtonRow(title: "Secondary Button", style: .secondary)
                ButtonRow(title: "Text Button", style: .text)
                ButtonRow(title: "With Icon", icon: "plus")
            }
        }
    }
}

struct InputsSection: View {
    @State private var text = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionTitle("Inputs")
            
            Group {
                YTextField("Regular Input", text: $text)
                YTextField("With Icon", text: $text, icon: "envelope")
                YTextField("Secure Input", text: $text, icon: "lock", isSecure: true)
            }
        }
    }
}

struct SpacingSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionTitle("Spacing")
            
            Group {
                SpacingRow(size: 8, name: "XSmall")
                SpacingRow(size: 16, name: "Small")
                SpacingRow(size: 24, name: "Medium")
                SpacingRow(size: 32, name: "Large")
                SpacingRow(size: 48, name: "XLarge")
            }
        }
    }
}

// Helper Views
struct SectionTitle: View {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TextStyleRow: View {
    let name: String
    let font: Font
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            Text("Sample Text")
                .font(font)
        }
    }
}

struct ColorRow: View {
    let name: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 60, height: 30)
        }
    }
}

struct ButtonRow: View {
    let title: String
    let style: YButtonStyle
    let icon: String?
    
    init(title: String, style: YButtonStyle = .primary, icon: String? = nil) {
        self.title = title
        self.style = style
        self.icon = icon
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.secondary)
            YButton(title: title, style: style, icon: icon) {}
        }
    }
}

struct SpacingRow: View {
    let size: CGFloat
    let name: String
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            Rectangle()
                .fill(Color.orange)
                .frame(width: size, height: 20)
            Text("\(Int(size))pt")
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    DesignSystemView()
}
