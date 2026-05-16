import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: FirebaseManager

    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "newspaper") }
            AppsView()
                .tabItem { Label("Apps", systemImage: "square.stack.3d.up") }
            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
            if authManager.isAdmin {
                AdminView()
                    .tabItem { Label("Admin", systemImage: "plus.square") }
            }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.circle") }
        }
        .accentColor(.blue)
    }
}
