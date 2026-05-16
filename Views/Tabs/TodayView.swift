import SwiftUI

struct TodayView: View {
    @StateObject private var service = AppStoreService()

    var body: some View {
        NavigationStack {
            ScrollView {
                if let featured = service.featuredApps.first {
                    VStack(alignment: .leading) {
                        Text("FEATURED").font(.caption.weight(.semibold)).foregroundColor(.secondary)
                        NavigationLink(destination: AppDetailView(app: featured)) {
                            TodayHeroCard(app: featured)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                }
                Text("More coming soon...")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
            .navigationTitle("Today")
            .task { await service.fetchApps() }
        }
    }
}

struct TodayHeroCard: View {
    let app: AppEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: app.iconURL)) { img in
                img.resizable().scaledToFit()
            } placeholder: { Color.gray }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(app.title).font(.title2.bold())
            Text(app.subtitle).font(.subheadline).foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
    }
}
