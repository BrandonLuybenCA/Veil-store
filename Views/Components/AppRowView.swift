import SwiftUI

struct AppRowView: View {
    let app: AppEntry
    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: app.iconURL)) { img in
                img.resizable().scaledToFit()
            } placeholder: { Color.gray }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading) {
                Text(app.title).font(.headline)
                Text(app.subtitle).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "icloud.and.arrow.down").foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
}
