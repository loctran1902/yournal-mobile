import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isGuest = false
    @Published var username = ""
    @Published var password = ""
    
    func signIn() {
        // Implement sign in logic
        isAuthenticated = true
    }
    
    func register() {
        // Implement registration logic
        isAuthenticated = true
    }
    
    func continueAsGuest() {
        isGuest = true
        isAuthenticated = true
    }
    
    func signOut() {
        isAuthenticated = false
        isGuest = false
    }
}
