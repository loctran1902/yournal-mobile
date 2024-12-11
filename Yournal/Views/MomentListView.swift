import SwiftUI
import SwiftData

struct MomentListView: View {
    // MARK: - Properties
    
    // Environment properties
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    // Observable object để theo dõi các thay đổi
    @StateObject private var viewModel: MomentListViewModel
    
    // Theme computed property
    private var theme: YTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    // MARK: - Initialization
    
    init() {
        // Tạo một ModelContainer tạm thời cho việc khởi tạo
        let schema = Schema([Moment.self])
        let modelConfiguration = ModelConfiguration(schema: schema)
        let container = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        
        // Tạo ModelContext từ container
        let context = ModelContext(container)
        let model = MomentListViewModel(modelContext: context)
        
        // Khởi tạo StateObject với model
        _viewModel = StateObject(wrappedValue: model)
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            MomentScrollView(
                moments: viewModel.moments,
                viewHeight: geometry.size.height,
                theme: theme,
                onReactionSelected: viewModel.handleReaction,
                onMomentChanged: { index in
                    viewModel.currentIndex = index
                    viewModel.preloadAdjacentMoments(at: index)
                }
            )
            .background(theme.background)
            .onAppear {
                // Cập nhật modelContext đúng khi view xuất hiện
                viewModel.updateModelContext(modelContext)
            }
        }
    }
}

// MARK: - Scroll View Component
private struct MomentScrollView: View {
    // Properties
    let moments: [Moment]
    let viewHeight: CGFloat
    let theme: YTheme
    let onReactionSelected: (Moment, String) -> Void
    let onMomentChanged: (Int) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(Array(moments.enumerated()), id: \.element.id) { index, moment in
                    MomentCard(
                        moment: moment,
                        height: viewHeight,
                        theme: theme,
                        onReactionSelected: onReactionSelected
                    )
                    .id(moment.id)
                    .onAppear {
                        onMomentChanged(index)
                    }
                }
            }
        }
        .scrollTargetBehavior(.paging)
    }
}

// MARK: - Card Component
private struct MomentCard: View {
    // Properties
    let moment: Moment
    let height: CGFloat
    let theme: YTheme
    let onReactionSelected: (Moment, String) -> Void
    
    // State
    @State private var showingFullCaption = false
    @State private var showingDetail = false
    
    var body: some View {
        ZStack {
            // Media Layer
            MediaLayer(moment: moment)
            
            // Overlay Layer
            OverlayLayer(
                moment: moment,
                theme: theme,
                showingFullCaption: $showingFullCaption,
                onReactionSelected: onReactionSelected
            )
        }
        .frame(height: height)
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                MomentDetailView(moment: moment)
            }
        }
    }
}

// MARK: - Supporting Components

private struct MediaLayer: View {
    let moment: Moment
    @State private var isLoading = true
    
    var body: some View {
        AsyncImage(url: moment.imageURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .onAppear { isLoading = false }
            case .failure:
                ErrorStateView()
            case .empty:
                LoadingStateView()
            @unknown default:
                EmptyView()
            }
        }
    }
}

private struct OverlayLayer: View {
    let moment: Moment
    let theme: YTheme
    @Binding var showingFullCaption: Bool
    let onReactionSelected: (Moment, String) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            // Caption Section
            CaptionSection(
                moment: moment,
                theme: theme,
                isExpanded: $showingFullCaption
            )
            
            // Reactions Section
            if !showingFullCaption {
                ReactionSection(
                    moment: moment,
                    theme: theme,
                    onReactionSelected: onReactionSelected
                )
            }
        }
    }
}

// MARK: - Helper Components

private struct CaptionSection: View {
    let moment: Moment
    let theme: YTheme
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Timestamp
            Text(moment.timestamp, style: .date)
                .font(.subheadline)
                .foregroundColor(theme.secondaryText)
            
            // Caption
            Text(moment.note)
                .lineLimit(isExpanded ? nil : 3)
                .foregroundColor(theme.text)
            
            // Location if available
            if let location = moment.location {
                HStack {
                    Image(systemName: "location.fill")
                    Text(location)
                }
                .font(.caption)
                .foregroundColor(theme.secondaryText)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}

private struct ReactionSection: View {
    let moment: Moment
    let theme: YTheme
    let onReactionSelected: (Moment, String) -> Void
    
    private let reactions = ["😊", "❤️", "😮", "😢", "👏", "🎉", "😍", "🙌"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(reactions, id: \.self) { emoji in
                    Text(emoji)
                        .font(.title2)
                        .onTapGesture {
                            onReactionSelected(moment, emoji)
                        }
                }
            }
            .padding()
        }
    }
}

private struct LoadingStateView: View {
    var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.3))
    }
}

private struct ErrorStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
            Text("Unable to load image")
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.3))
    }
}

// MARK: - Preview
#Preview {
    MomentListView()
}
