import SwiftUI

struct AppsView: View {
    @StateObject private var service = AppStoreService()
    @State private var selectedCategory: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(allCategories, id: \.self) { cat in
                            Text(cat)
                                .padding(.horizontal, 16).padding(.vertical, 8)
                                .background(selectedCategory == cat ? Color.blue : Color(.systemGray5))
                                .foregroundColor(selectedCategory == cat ? .white : .primary)
                                .clipShape(Capsule())
                                .onTapGesture {
                                    selectedCategory = (selectedCategory == cat) ? nil : cat
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                List(filteredApps) { app in
                    NavigationLink(destination: AppDetailView(app: app)) {
                        AppRowView(app: app)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Apps")
            .task { await service.fetchApps() }
        }
    }

    var allCategories: [String] { Array(service.categories.keys).sorted() }
    var filteredApps: [AppEntry] {
        guard let cat = selectedCategory else { return service.allApps }
        return service.categories[cat] ?? []
    }
}
