import SwiftUI
import SwiftData

struct MomentListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var moments: [Moment] = Moment.mockData()
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    ProfileView()
                }
                
                // Moments Section
                Section {
                    ForEach(moments) { moment in
                        NavigationLink(destination: MomentDetailView(moment: moment)) {
                            MomentCell(moment: moment)
                        }
                    }
                    .onDelete(perform: deleteMoments)
                }
            }
            .navigationTitle("Moments")
            .toolbar {
                EditButton()
            }
        }
    }
    
    private func deleteMoments(offsets: IndexSet) {
        withAnimation {
            moments.remove(atOffsets: offsets)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading) {
                    Text("Felix Fool")
                        .font(.headline)
                    Text("felixfool.ig")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Text("Life is in color, but black and white is more realistic")
                .font(.body)
            Link("bahoastory.com", destination: URL(string: "https://bahoastory.com")!)
                .font(.body)
                .foregroundColor(.blue)
        }
        .padding()
    }
}

struct MomentCell: View {
    let moment: Moment
    
    var body: some View {
        HStack {
            if let url = moment.imageURL,
               let uiImage = UIImage(contentsOfFile: url.path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(moment.note)
                    .lineLimit(2)
                Text(moment.timestamp, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MomentListView()
}
