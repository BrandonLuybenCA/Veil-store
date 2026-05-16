import SwiftUI

struct SearchView: View {
    @StateObject private var service = AppStoreService()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List(searchResults) { app in
                NavigationLink(destination: AppDetailView(app: app)) {
                    AppRowView(app: app)
                }
            }
            .searchable(text: $searchText, prompt: "Search apps")
            .navigationTitle("Search")
            .task { await service.fetchApps() }
        }
    }

    var searchResults: [AppEntry] {
        guard !searchText.isEmpty else { return service.allApps }
        return service.allApps.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }
}
