import SwiftUI
import SwiftData

struct MomentDetailView: View {
    let moment: Moment
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = moment.imageURL,
                   let uiImage = UIImage(contentsOfFile: url.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(moment.timestamp, style: .date)
                        .foregroundColor(.secondary)
                    
                    Text(moment.note)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Moment Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MomentDetailView(moment: Moment.mockData()[0])
}