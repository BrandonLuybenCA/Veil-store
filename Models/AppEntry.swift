import FirebaseFirestore

struct AppEntry: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var subtitle: String
    var description: String
    var iconURL: String
    var screenshots: [String]
    var category: String
    var manifestURL: String
    var version: String
    var sizeMB: Double
    var featured: Bool
    var isActive: Bool
}
