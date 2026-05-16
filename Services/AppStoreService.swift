import SwiftUI

class AppStoreService: ObservableObject {
    @Published var allApps: [AppEntry] = []
    @Published var featuredApps: [AppEntry] = []
    @Published var categories: [String: [AppEntry]] = [:]

    // Replace this URL with the raw URL of your apps.json file on GitHub
    private let jsonURL = "https://raw.githubusercontent.com/YOUR_USERNAME/Veil/main/apps.json"

    func fetchApps() async {
        guard let url = URL(string: jsonURL) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let apps = try JSONDecoder().decode([AppEntry].self, from: data)
            await MainActor.run {
                self.allApps = apps
                self.featuredApps = apps.filter { $0.featured }
                self.categories = Dictionary(grouping: apps, by: { $0.category })
            }
        } catch {
            print("Failed to load apps: \(error)")
        }
    }
}
