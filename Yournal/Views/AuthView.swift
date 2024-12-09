import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var showingRegistration = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Yournal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Sign In") {
                        viewModel.signIn()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Register") {
                        showingRegistration = true
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                
                Button("Continue as Guest") {
                    viewModel.continueAsGuest()
                }
                .padding()
            }
            .padding()
        }
    }
}
