import SwiftUI
import SwiftData

final class MomentListViewModel: ObservableObject {
    // MARK: - Published Properties
    
    // Danh sách moments có thể được quan sát từ View
    @Published private(set) var moments: [Moment] = []
    
    // Index của moment hiện tại đang được hiển thị
    @Published var currentIndex: Int = 0
    
    // MARK: - Private Properties
    
    // ModelContext để tương tác với SwiftData
    private var modelContext: ModelContext
    
    // Số lượng moments sẽ được preload trước và sau moment hiện tại
    private let preloadOffset = 2
    
    // MARK: - Initialization
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        // Khi khởi tạo, chúng ta load dữ liệu và thiết lập observers
        loadMoments()
        setupObservers()
    }
    
    // MARK: - Public Methods
    
    // Phương thức để cập nhật modelContext khi cần
    func updateModelContext(_ newContext: ModelContext) {
        self.modelContext = newContext
        loadMoments()
    }
    
    // Xử lý khi người dùng thêm reaction cho một moment
    func handleReaction(for moment: Moment, emoji: String) {
        // Đảm bảo moment tồn tại trong danh sách
        guard moments.firstIndex(where: { $0.id == moment.id }) != nil else { return }
        
        // TODO: Implement reaction handling logic
        // Ví dụ:
        // - Thêm reaction vào moment
        // - Cập nhật trong database
        // - Gửi thông báo nếu cần
    }
    
    // Tải trước dữ liệu cho các moments xung quanh
    func preloadAdjacentMoments(at index: Int) {
        let startIndex = max(0, index - preloadOffset)
        let endIndex = min(moments.count - 1, index + preloadOffset)
        
        for i in startIndex...endIndex where i != index {
            // Chỉ preload nếu moment chưa được load
            if let moment = moments[safe: i] {
                preloadContent(for: moment)
            }
        }
    }
    
    // MARK: - Private Methods
    
    // Load danh sách moments từ database
    private func loadMoments() {
        do {
            // Tạo descriptor để sắp xếp moments theo thời gian
            let sortDescriptor = SortDescriptor<Moment>(\.timestamp, order: .reverse)
            
            // Tạo fetch descriptor với sort descriptor
            let descriptor = FetchDescriptor<Moment>(sortBy: [sortDescriptor])
            
            // Thực hiện fetch và cập nhật published property
            moments = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching moments: \(error)")
        }
    }
    
    // Thiết lập observers để theo dõi thay đổi của database
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("MomentDidChange"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.loadMoments()
        }
    }
    
    // Preload content cho một moment cụ thể
    private func preloadContent(for moment: Moment) {
        // TODO: Implement preloading logic
        // Ví dụ:
        // - Preload hình ảnh
        // - Cache dữ liệu cần thiết
        // - Tải trước metadata nếu cần
    }
}

// MARK: - Helper Extensions

extension Collection {
    // Extension để an toàn khi truy cập phần tử theo index
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
