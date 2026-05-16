import SwiftUI

struct AdminView: View {
    @StateObject private var service = AppStoreService()
    @State private var title = ""
    @State private var subtitle = ""
    @State private var description = ""
    @State private var iconURL = ""
    @State private var screenshots: String = "" // comma separated
    @State private var category = "Utilities"
    @State private var manifestURL = ""
    @State private var version = "1.0"
    @State private var sizeMB = ""
    @State private var featured = false
    @State private var isActive = true

    @State private var uploadMessage = ""
    @State private var showMessage = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("App Info")) {
                    TextField("Title", text: $title)
                    TextField("Subtitle", text: $subtitle)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(4)
                    TextField("Icon URL", text: $iconURL)
                    TextField("Screenshots (comma-separated URLs)", text: $screenshots)
                    TextField("Category", text: $category)
                    TextField("Manifest URL", text: $manifestURL)
                    TextField("Version", text: $version)
                    TextField("Size (MB)", text: $sizeMB)
                        .keyboardType(.decimalPad)
                    Toggle("Featured", isOn: $featured)
                    Toggle("Active", isOn: $isActive)
                }

                Section {
                    Button("Upload App") {
                        uploadApp()
                    }
                    .disabled(title.isEmpty || manifestURL.isEmpty)
                }
            }
            .navigationTitle("Add App")
            .alert("Upload", isPresented: $showMessage) {
                Button("OK") {}
            } message: {
                Text(uploadMessage)
            }
        }
    }

    private func uploadApp() {
        guard let size = Double(sizeMB) else {
            uploadMessage = "Invalid size"
            showMessage = true
            return
        }

        let app = AppEntry(
            title: title,
            subtitle: subtitle,
            description: description,
            iconURL: iconURL,
            screenshots: screenshots.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            category: category,
            manifestURL: manifestURL,
            version: version,
            sizeMB: size,
            featured: featured,
            isActive: isActive
        )

        Task {
            do {
                try await service.addApp(app)
                uploadMessage = "App uploaded successfully!"
                showMessage = true
                clearForm()
            } catch {
                uploadMessage = "Error: \(error.localizedDescription)"
                showMessage = true
            }
        }
    }

    private func clearForm() {
        title = ""
        subtitle = ""
        description = ""
        iconURL = ""
        screenshots = ""
        category = "Utilities"
        manifestURL = ""
        version = "1.0"
        sizeMB = ""
        featured = false
        isActive = true
    }
}
