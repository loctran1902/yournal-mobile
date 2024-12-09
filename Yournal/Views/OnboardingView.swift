import SwiftUI

struct OnboardingView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: YTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Phone illustration
                ZStack {
                    // Phone frame
                    RoundedRectangle(cornerRadius: 40)
                        .strokeBorder(.gray, lineWidth: 4)
                        .frame(width: 200, height: 380)
                    
                    // App grid
                    VStack(spacing: 12) {
                        ForEach(0..<4) { row in
                            HStack(spacing: 12) {
                                ForEach(0..<4) { column in
                                    if row == 0 && column == 0 {
                                        // Demo profile picture
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.orange)
                                            .frame(width: 32, height: 32)
                                            .overlay(
                                                Image(systemName: "person.fill")
                                                    .foregroundColor(.white)
                                            )
                                    } else {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 32, height: 32)
                                    }
                                }
                            }
                        }
                        
                        // Dock
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 160, height: 20)
                            .padding(.top, 30)
                    }
                }
                
                Spacer()
                
                // App logo and name
                HStack(spacing: 8) {
                    Image(systemName: "heart.square.fill")
                        .foregroundColor(.orange)
                        .font(.title)
                    
                    Text("Yournal")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                // Tagline
                Text("Live pics from your friends,\non your home screen")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
                
                // Buttons
                VStack(spacing: 16) {
                    YButton(
                        title: "Create an account",
                        style: .primary
                    ) {
                        // Handle create account
                    }
                    .padding(.horizontal, 24)
                    
                    YButton(
                        title: "Sign in",
                        style: .text
                    ) {
                        // Handle sign in
                    }
                }
                
                Spacer()
                    .frame(height: 40)
            }
        }
    }
}

#Preview {
    Group {
        OnboardingView()
            .environment(\.colorScheme, .dark)
    }
} 