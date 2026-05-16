import SwiftUI

struct InstallButton: View {
    let manifestURL: String

    var body: some View {
        Button {
            if let url = URL(string: "itms-services://?action=download-manifest&url=\(manifestURL)") {
                UIApplication.shared.open(url)
            }
        } label: {
            Label("Install", systemImage: "icloud.and.arrow.down")
                .frame(maxWidth: .infinity)
                .font(.headline)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}
