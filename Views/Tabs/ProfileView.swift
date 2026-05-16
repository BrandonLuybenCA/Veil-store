import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable().frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Veil User").font(.headline)
                            Text("Welcome to your store").font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
