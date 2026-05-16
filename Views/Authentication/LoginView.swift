import SwiftUI
import FirebaseAuth
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authManager: FirebaseManager
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showError = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "v.square.fill")
                .resizable().scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            Text("Veil").font(.largeTitle.bold())
            Text("Sign in to your store").foregroundColor(.secondary)

            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding().background(Color(.systemGray6)).cornerRadius(10)

            SecureField("Password", text: $password)
                .padding().background(Color(.systemGray6)).cornerRadius(10)

            Button("Sign In") { signIn() }
                .buttonStyle(.borderedProminent)
                .disabled(email.isEmpty || password.isEmpty)

            Button("Create Account") { createAccount() }
                .buttonStyle(.bordered)

            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
                handleAppleSignIn(result)
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 44)

            Spacer()
        }
        .padding()
        .alert("Error", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { _, err in
            if let err = err { errorMessage = err.localizedDescription; showError = true }
        }
    }

    private func createAccount() {
        Auth.auth().createUser(withEmail: email, password: password) { _, err in
            if let err = err { errorMessage = err.localizedDescription; showError = true }
        }
    }

    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let cred = auth.credential as? ASAuthorizationAppleIDCredential,
               let token = cred.identityToken,
               let tokenStr = String(data: token, encoding: .utf8) {
                let firebaseCred = OAuthProvider.credential(withProviderID: "apple.com",
                                                            idToken: tokenStr,
                                                            rawNonce: nil)
                Auth.auth().signIn(with: firebaseCred) { _, err in
                    if let err = err { errorMessage = err.localizedDescription; showError = true }
                }
            }
        case .failure(let err):
            errorMessage = err.localizedDescription; showError = true
        }
    }
}
