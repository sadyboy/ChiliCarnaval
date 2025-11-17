import SwiftUI

struct SettingsView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("musicEnabled") private var musicEnabled = true
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    @AppStorage("difficulty") private var difficulty = "Medium"
    @AppStorage("playerName") private var playerName = "Player"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("appearance") private var appearance = "System"
    
    @State private var showResetAlert = false
    @State private var showResetSuccess = false
    
    let onBack: () -> Void
    let difficulties = ["Easy", "Medium", "Hard", "Extreme"]
    let appearances = ["System", "Light", "Dark"]
    
    var body: some View {
        ZStack {
        
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(
                                LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
                            )
                            .clipShape(Circle())
                            .shadow(color: .orange.opacity(0.4), radius: 3, x: 0, y: 2)
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.custom("PeppaBold", size: 32))
                        .foregroundColor(.black)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                    
                    Spacer()
                    
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(Circle())
                        .shadow(color: .red.opacity(0.4), radius: 3, x: 0, y: 2)
                }
                .padding()
//                .background(
//                    LinearGradient(
//                        colors: [.orange.opacity(0.8), .red.opacity(0.7)],
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                )
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Player settings
                        SettingsSection(title: "Player Profile", icon: "person.circle.fill", color: .orange) {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.orange)
                                    Text("Player Name")
                                        .font(.custom("PeppaBold", size: 16))
                                        .foregroundColor(.white)
                                }
                                
                                TextField("Enter your name", text: $playerName)
                                    .padding()
                                    .background(Color.orange.opacity(0.2))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                                    )
                                    .font(.custom("PeppaBold", size: 16))
                                    .foregroundColor(.white)
                                    .accentColor(.orange)
                            }
                        }
                        
                        // Audio settings
                        SettingsSection(title: "Audio Settings", icon: "speaker.wave.3.fill", color: .yellow) {
                            VStack(spacing: 12) {
                                ToggleSetting(
                                    isOn: $soundEnabled,
                                    title: "Sound Effects",
                                    icon: "speaker.wave.2",
                                    color: .yellow
                                )
                                
                                Divider()
                                    .background(Color.yellow.opacity(0.4))
                                
                                ToggleSetting(
                                    isOn: $musicEnabled,
                                    title: "Background Music",
                                    icon: "music.note",
                                    color: .yellow
                                )
                            }
                        }
                        
                        // Haptic settings
                        SettingsSection(title: "Vibration & Feedback", icon: "iphone.radiowaves.left.and.right", color: .red) {
                            ToggleSetting(
                                isOn: $hapticEnabled,
                                title: "Haptic Feedback",
                                icon: "water.waves",
                                color: .red,
                                subtitle: "Get vibration feedback for actions"
                            )
                        }
                        
                        // Notifications
                        SettingsSection(title: "Notifications", icon: "bell.badge.fill", color: .pink) {
                            ToggleSetting(
                                isOn: $notificationsEnabled,
                                title: "Push Notifications",
                                icon: "bell.fill",
                                color: .pink,
                                subtitle: "Receive game updates and reminders"
                            )
                        }
                        
                        // Appearance
//                        SettingsSection(title: "Appearance", icon: "paintbrush.fill", color: .purple) {
//                            VStack(alignment: .leading, spacing: 12) {
//                                Text("Theme")
//                                    .font(.custom("PeppaBold", size: 15))
//                                    .foregroundColor(.white.opacity(0.8))
//                                
//                                Picker("Appearance", selection: $appearance) {
//                                    ForEach(appearances, id: \.self) { theme in
//                                        HStack {
//                                            Image(systemName: iconForAppearance(theme))
//                                                .foregroundColor(.white)
//                                            Text(theme)
//                                                .foregroundColor(.white)
//                                        }
//                                        .tag(theme)
//                                    }
//                                }
//                                .pickerStyle(.segmented)
//                                .padding(.vertical, 5)
//                            }
//                        }
                        
                        // Game settings
                        SettingsSection(title: "Game Settings", icon: "gamecontroller.fill", color: .green) {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Difficulty Level")
                                    .font(.custom("PeppaBold", size: 15))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                VStack(spacing: 8) {
                                    ForEach(difficulties, id: \.self) { diff in
                                        DifficultyRow(
                                            title: diff,
                                            isSelected: difficulty == diff,
                                            color: colorForDifficulty(diff)
                                        ) {
                                            withAnimation(.spring(response: 0.3)) {
                                                difficulty = diff
                                            }
                                        }
                                    }
                                }
                                
                                Text(difficultyDescription)
                                    .font(.custom("PeppaBold", size: 12))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.top, 5)
                            }
                        }
                        
                        // Reset data
                        SettingsSection(title: "Data Management", icon: "internaldrive.fill", color: .gray) {
                            VStack(spacing: 15) {
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showResetAlert = true
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.white)
                                        Text("Reset All Game Data")
                                            .font(.custom("PeppaBold", size: 16))
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .cornerRadius(12)
                                    .shadow(color: .red.opacity(0.5), radius: 8, x: 0, y: 4)
                                }
                                
                                Text("This will delete all your progress and settings")
                                    .font(.custom("PeppaBold", size: 11))
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        // Version info
                        VStack(spacing: 5) {
                            Text("Pepper Quest v1.0")
                                .font(.custom("PeppaBold", size: 14))
                                .foregroundColor(.white)
                            Text("Spice up your life! 🌶️")
                                .font(.custom("PeppaBold", size: 12))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 10)
                    }
                    .padding(.vertical)
                }
            }
        }
        .alert("Reset All Data?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will permanently delete all your game progress, unlocked peppers, and settings. This action cannot be undone.")
        }
        .alert("Data Reset Successfully", isPresented: $showResetSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("All game data has been reset to default settings.")
        }
    }
    
    private var difficultyDescription: String {
        switch difficulty {
        case "Easy":
            return "Relaxed gameplay with more time and hints"
        case "Medium":
            return "Balanced challenge for most players"
        case "Hard":
            return "Tough challenges for experienced players"
        case "Extreme":
            return "Maximum difficulty - for spice masters only!"
        default:
            return "Select your challenge level"
        }
    }
    
    private func colorForDifficulty(_ difficulty: String) -> Color {
        switch difficulty {
        case "Easy": return .green
        case "Medium": return .yellow
        case "Hard": return .orange
        case "Extreme": return .red
        default: return .blue
        }
    }
    
    private func iconForAppearance(_ theme: String) -> String {
        switch theme {
        case "Light": return "sun.max.fill"
        case "Dark": return "moon.fill"
        default: return "circle.lefthalf.filled"
        }
    }
    
    private func resetAllData() {
        // Reset all settings to default
        soundEnabled = true
        musicEnabled = true
        hapticEnabled = true
        difficulty = "Medium"
        playerName = "Player"
        notificationsEnabled = true
        appearance = "System"
        
        // Reset game data
        DataManager.shared.resetAllData()
        
        // Show success message
        showResetSuccess = true
        
        // Haptic feedback
        if hapticEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: color.opacity(0.5), radius: 3, x: 0, y: 2)
                
                Text(title)
                    .font(.custom("PeppaBold", size: 20))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [
                    Color.orange.opacity(0.5),
                    Color.red.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.4), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct ToggleSetting: View {
    @Binding var isOn: Bool
    let title: String
    let icon: String
    let color: Color
    var subtitle: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("PeppaBold", size: 16))
                        .foregroundColor(.white)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.custom("PeppaBold", size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .tint(color)
                    .scaleEffect(0.8)
            }
        }
    }
}

struct DifficultyRow: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? color : .white.opacity(0.6))
                
                Text(title)
                    .font(.custom("PeppaBold", size: 16))
                    .foregroundColor(isSelected ? color : .white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "flame.fill")
                        .foregroundColor(color)
                }
            }
            .padding()
            .background(
                isSelected ?
                color.opacity(0.2) :
                Color.white.opacity(0.1)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? color.opacity(0.5) : Color.white.opacity(0.2), lineWidth: 2)
            )
        }
    }
}

#Preview {
    SettingsView(onBack: {})
}
