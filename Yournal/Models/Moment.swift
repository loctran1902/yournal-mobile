import SwiftData
import UIKit

@Model
final class Moment {
    var id: UUID
    var imageURL: URL?
    var note: String
    var timestamp: Date
    var location: String?
    
    init(id: UUID = UUID(), 
         imageURL: URL? = nil, 
         note: String = "", 
         timestamp: Date = Date(),
         location: String? = nil) {
        self.id = id
        self.imageURL = imageURL
        self.note = note
        self.timestamp = timestamp
        self.location = location
    }
} 