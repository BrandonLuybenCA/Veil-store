import SwiftUI

struct AppDetailView: View {
    let app: AppEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: app.iconURL)) { img in
                        img.resizable().scaledToFit()
                    } placeholder: { Color.gray }
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    VStack(alignment: .leading) {
                        Text(app.title).font(.title2.bold())
                        Text(app.subtitle).font(.subheadline).foregroundColor(.secondary)
                        Text("Version \(app.version) • \(String(format: "%.1f", app.sizeMB)) MB")
                            .font(.caption).foregroundColor(.secondary)
                    }
                }
                InstallButton(manifestURL: app.manifestURL)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(app.screenshots, id: \.self) { url in
                            AsyncImage(url: URL(string: url)) { img in
                                img.resizable().scaledToFill()
                            } placeholder: { Color.gray }
                            .frame(width: 200, height: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal)
                }
                Text(app.description).font(.body).padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle(app.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
