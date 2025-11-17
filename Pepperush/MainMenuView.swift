import SwiftUI

struct MainMenuView: View {
    @State private var selectedTab: Tab = .menu
    @State private var animateTitle = false
    @State private var animatePeppers = false
    
    enum Tab {
        case menu, game, encyclopedia, profile, leaderboard, settings
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            Image(.backMain)
                .resizable()
                .ignoresSafeArea()
              
            if selectedTab == .menu {
                menuContent
            } else if selectedTab == .game {
                GameView(onBack: { selectedTab = .menu })
            } else if selectedTab == .encyclopedia {
                EncyclopediaView(onBack: { selectedTab = .menu })
            } else if selectedTab == .profile {
                ProfileView(onBack: { selectedTab = .menu })
            } else if selectedTab == .leaderboard {
                LeaderboardView(onBack: { selectedTab = .menu })
            } else if selectedTab == .settings {
                SettingsView(onBack: { selectedTab = .menu })
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                animateTitle = true
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animatePeppers = true
            }
        }
    }
    
    var menuContent: some View {
        ScrollView {
            VStack(spacing: 10) {
                Spacer()
                // Animated title
                VStack(spacing: 10) {
                    Image(.mainPapper)
                        .resizable()
                        .frame(width: 100, height: 140)
                        .rotationEffect(.degrees(animateTitle ? -10 : 10))
                        .scaleEffect(animateTitle ? 1.1 : 1.0)
                    
                    Text("Chili Carnival")
                        .font(.custom("PeppaBold", size: 49))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                    
                    Text("Collect all the peppers!")
                        .font(.custom("PeppaBold", size: 22))
                        .foregroundColor(.white.opacity(0.9))
                }
                .offset(y: animatePeppers ? -10 : 10)
                
                Spacer()
                
                // Menu buttons
                VStack(spacing: 0) {
                    MenuButton(
                        icon: "gamecontroller.fill",
                        title: "Play",
                        gradient: [.green, .blue]
                    ) {
                        selectedTab = .game
                    }
                    
                    MenuButton(
                        icon: "book.fill",
                        title: "Encyclopedia",
                        gradient: [.orange, .red]
                    ) {
                        selectedTab = .encyclopedia
                    }
                    
                    MenuButton(
                        icon: "person.fill",
                        title: "Profile",
                        gradient: [.purple, .pink]
                    ) {
                        selectedTab = .profile
                    }
                    
                    MenuButton(
                        icon: "chart.bar.fill",
                        title: "Leaderboard",
                        gradient: [.yellow, .orange]
                    ) {
                        selectedTab = .leaderboard
                    }
                    
                    MenuButton(
                        icon: "gearshape.fill",
                        title: "Settings",
                        gradient: [.gray, .blue]
                    ) {
                        selectedTab = .settings
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
    }
}

struct MenuButton: View {
    let icon: String
    let title: String
    let gradient: [Color]
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
            HStack {
                Image(icon)
                    .resizable()
                    .scaledToFill()
                   .font(.custom("PeppaBold", size: 22))

            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .foregroundColor(.white)
            .padding()
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
    }
}

#Preview {
    MainMenuView()
}
