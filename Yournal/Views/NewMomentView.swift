import SwiftUI
import SwiftData

struct NewMomentView: View {
    let image: UIImage?
    let imageURL: URL?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var note: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                }
                
                TextField("Add a note...", text: $note, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(4...6)
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Moment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMoment()
                    }
                    .disabled(imageURL == nil)
                }
            }
        }
    }
    
    private func saveMoment() {
        guard let imageURL = imageURL else { return }
        
        let moment = Moment(
            imageURL: imageURL,
            note: note,
            timestamp: Date()
        )
        
        modelContext.insert(moment)
        
        dismiss()
    }
}

#Preview {
    NewMomentView(image: nil, imageURL: nil)
}