import Foundation

extension Moment {
    static func mockData() -> [Moment] {
        let calendar = Calendar.current
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        return [
            Moment(
                imageURL: documentsDirectory.appendingPathComponent("sunset.jpg"),
                note: "A beautiful sunset at the beach. The colors were absolutely breathtaking!",
                timestamp: calendar.date(byAdding: .hour, value: -2, to: Date()) ?? Date()
            ),
            Moment(
                imageURL: documentsDirectory.appendingPathComponent("coffee.jpg"),
                note: "Morning coffee at my favorite café. Perfect way to start the day!",
                timestamp: calendar.date(byAdding: .hour, value: -5, to: Date()) ?? Date()
            ),
            Moment(
                imageURL: documentsDirectory.appendingPathComponent("hike.jpg"),
                note: "Weekend hike in the mountains. The fresh air was rejuvenating!",
                timestamp: calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            ),
            Moment(
                imageURL: documentsDirectory.appendingPathComponent("dinner.jpg"),
                note: "Family dinner - mom's special recipe never disappoints",
                timestamp: calendar.date(byAdding: .day, value: -2, to: Date()) ?? Date()
            )
        ]
    }
}