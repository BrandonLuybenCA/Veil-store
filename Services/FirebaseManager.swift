import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isAdmin = false

    private var authHandle: AuthStateDidChangeListenerHandle?
    private var userDocListener: ListenerRegistration?

    init() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.currentUser = user
                self.isAuthenticated = user != nil
            }
            // Remove previous listener
            self.userDocListener?.remove()
            guard let user = user else {
                self.isAdmin = false
                return
            }
            // Listen to user document in Firestore
            let db = Firestore.firestore()
            self.userDocListener = db.collection("users").document(user.uid)
                .addSnapshotListener { snapshot, error in
                    if let data = snapshot?.data(), let role = data["role"] as? String {
                        DispatchQueue.main.async {
                            self.isAdmin = (role == "admin")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.isAdmin = false
                        }
                    }
                }
        }
    }

    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        userDocListener?.remove()
    }

    func signOut() {
        try? Auth.auth().signOut()
    }
}
