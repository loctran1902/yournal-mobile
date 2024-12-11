import SwiftUI
import SwiftData

struct MomentDetailView: View {
    let moment: Moment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingFullCaption = false
    
    private var theme: YTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Phần hiển thị media chính
                MediaContentSection(moment: moment)
                
                // Phần thông tin và tương tác
                VStack(alignment: .leading, spacing: 12) {
                    // Timestamp và Location
                    TimestampLocationView(moment: moment, theme: theme)
                    
                    // Caption/Note có thể mở rộng
                    CaptionView(
                        text: moment.note,
                        isExpanded: $isShowingFullCaption,
                        theme: theme
                    )
                    
                    // Phần reactions
                    ReactionSection(moment: moment, theme: theme)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Moment Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(theme.background)
    }
}

// MARK: - Supporting Views

private struct MediaContentSection: View {
    let moment: Moment
    
    var body: some View {
        if let url = moment.imageURL,
           let uiImage = UIImage(contentsOfFile: url.path) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        }
    }
}

private struct TimestampLocationView: View {
    let moment: Moment
    let theme: YTheme
    
    var body: some View {
        HStack {
            Text(moment.timestamp, style: .date)
            
            if let location = moment.location {
                Divider()
                    .frame(height: 12)
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                    Text(location)
                }
            }
        }
        .font(.subheadline)
        .foregroundColor(theme.secondaryText)
    }
}

private struct CaptionView: View {
    let text: String
    @Binding var isExpanded: Bool
    let theme: YTheme
    
    var body: some View {
        Text(text)
            .font(.body)
            .foregroundColor(theme.text)
            .lineLimit(isExpanded ? nil : 3)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }
    }
}

private struct ReactionSection: View {
    let moment: Moment
    let theme: YTheme
    @State private var selectedEmoji: String?
    
    private let reactions = ["😊", "❤️", "😮", "😢", "👏", "🎉", "😍", "🙌"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reactions")
                .font(.headline)
                .foregroundColor(theme.text)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(reactions, id: \.self) { emoji in
                        Text(emoji)
                            .font(.title2)
                            .opacity(selectedEmoji == emoji ? 1 : 0.7)
                            .scaleEffect(selectedEmoji == emoji ? 1.2 : 1)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedEmoji = emoji
                                }
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        MomentDetailView(moment: Moment.mockData()[0])
    }
}
