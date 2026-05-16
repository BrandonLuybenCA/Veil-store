import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: FirebaseManager

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable().frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text(authManager.currentUser?.email ?? "User").font(.headline)
                            Text(authManager.isAdmin ? "Admin" : "User").font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
                Section {
                    Button("Sign Out", role: .destructive) {
                        authManager.signOut()
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
