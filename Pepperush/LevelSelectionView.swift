import SwiftUI

// MARK: - Level Selection View
struct LevelSelectionView: View {
    @StateObject private var viewModel = LevelSelectionViewModel()
    let onBack: () -> Void
    let onLevelSelected: (Int) -> Void
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.orange.opacity(0.4),
                Color.red.opacity(0.3),
                Color.orange.opacity(0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var headerGradient: LinearGradient {
        LinearGradient(
            colors: [.orange.opacity(0.8), .red.opacity(0.7)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        ZStack {

            VStack(spacing: 0) {
                headerView
                levelsGridView
                statsView
            }
        }
        .onAppear {
            viewModel.loadUnlockedLevels()
        }
    }
    
    private var headerView: some View {
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
            
            Text("Select Level")
                .font(.custom("PeppaBold", size: 32))
                .foregroundColor(.black)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            
            Spacer()
            
            Image(systemName: "flag.fill")
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
//        .background(headerGradient)
    }
    
    private var levelsGridView: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                ForEach(1...15, id: \.self) { level in
                    LevelButton(
                        level: level,
                        isUnlocked: viewModel.isLevelUnlocked(level),
                        isCompleted: viewModel.isLevelCompleted(level),
                        onSelect: { onLevelSelected(level) }
                    )
                }
            }
            .padding()
        }
    }
    
    private var statsView: some View {
        VStack(spacing: 15) {
            HStack(spacing: 20) {
                StatBadge(
                    title: "Completed",
                    value: "\(viewModel.completedLevels)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                StatBadge(
                    title: "Unlocked",
                    value: "\(viewModel.unlockedLevels)",
                    icon: "lock.open.fill",
                    color: .blue
                )
                
                StatBadge(
                    title: "Total",
                    value: "15",
                    icon: "number.circle.fill",
                    color: .orange
                )
            }
            .padding(.horizontal)
            
            Text("Complete levels to unlock new challenges!")
                .font(.custom("PeppaBold", size: 14))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 20)
        .background(
            LinearGradient(
                colors: [.orange.opacity(0.3), .red.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct LevelButton: View {
    let level: Int
    let isUnlocked: Bool
    let isCompleted: Bool
    let onSelect: () -> Void
    
    private var levelColor: Color {
        switch level {
        case 1...5: return .green
        case 6...10: return .yellow
        case 11...15: return .red
        default: return .blue
        }
    }
    
    private var levelIcon: String {
        switch level {
        case 1: return "🌶️"
        case 2: return "🔥"
        case 3: return "⚡"
        case 4: return "🎯"
        case 5: return "🚀"
        case 6: return "💎"
        case 7: return "👑"
        case 8: return "⭐"
        case 9: return "🌈"
        case 10: return "🎪"
        case 11: return "💀"
        case 12: return "☠️"
        case 13: return "👻"
        case 14: return "🤖"
        case 15: return "🦄"
        default: return "🎮"
        }
    }
    
    var body: some View {
        Button(action: {
            if isUnlocked {
                onSelect()
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            isUnlocked ?
                            LinearGradient(
                                colors: [levelColor, levelColor.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            ) :
                            LinearGradient(
                                colors: [.gray, .gray.opacity(0.5)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 70, height: 70)
                        .shadow(
                            color: isUnlocked ? levelColor.opacity(0.5) : .gray.opacity(0.3),
                            radius: 5,
                            x: 0,
                            y: 3
                        )
                    
                    if isUnlocked {
                        Text(levelIcon)
                            .font(.system(size: 30))
                        
                        if isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                                .background(Color.green.clipShape(Circle()))
                                .offset(x: 25, y: -25)
                        }
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                
                Text("Level \(level)")
                    .font(.custom("PeppaBold", size: 14))
                    .foregroundColor(isUnlocked ? .white : .gray)
                
                if isUnlocked {
                    Text(getLevelDescription(level))
                        .font(.custom("PeppaBold", size: 10))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(10)
            .background(
                isUnlocked ?
                Color.white.opacity(0.1) :
                Color.gray.opacity(0.1)
            )
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        isUnlocked ? levelColor.opacity(0.3) : Color.gray.opacity(0.2),
                        lineWidth: 2
                    )
            )
        }
        .disabled(!isUnlocked)
    }
    
    private func getLevelDescription(_ level: Int) -> String {
        switch level {
        case 1: return "Beginner\nEasy peppers"
        case 2: return "Warming Up\nMore speed"
        case 3: return "Getting Hot\nFaster peppers"
        case 4: return "Spicy!\nMixed types"
        case 5: return "Fire Starter\nAll pepper types"
        case 6: return "Heat Wave\nMore bad items"
        case 7: return "Inferno\nVery fast"
        case 8: return "Volcano\nExtreme speed"
        case 9: return "Meltdown\nChaos mode"
        case 10: return "Impossible\nSurvival test"
        case 11: return "Nightmare\nNo mercy"
        case 12: return "Hellfire\nUltra hard"
        case 13: return "Apocalypse\nNearly impossible"
        case 14: return "Legendary\nFor masters only"
        case 15: return "Mythic\nThe ultimate challenge"
        default: return "Unknown level"
        }
    }
}

// MARK: - Level Selection ViewModel
class LevelSelectionViewModel: ObservableObject {
    @Published var unlockedLevels: Set<Int> = [1] // Level 1 unlocked by default
    @Published var completedLevels: Set<Int> = []
    
    private let unlockedLevelsKey = "unlockedLevels"
    private let completedLevelsKey = "completedLevels"
    
    func loadUnlockedLevels() {
        // Load unlocked levels from UserDefaults
        if let savedUnlocked = UserDefaults.standard.array(forKey: unlockedLevelsKey) as? [Int] {
            unlockedLevels = Set(savedUnlocked)
        } else {
            // First time - only level 1 is unlocked
            unlockedLevels = [1]
            saveUnlockedLevels()
        }
        
        // Load completed levels
        if let savedCompleted = UserDefaults.standard.array(forKey: completedLevelsKey) as? [Int] {
            completedLevels = Set(savedCompleted)
        }
    }
    
    func isLevelUnlocked(_ level: Int) -> Bool {
        return unlockedLevels.contains(level)
    }
    
    func isLevelCompleted(_ level: Int) -> Bool {
        return completedLevels.contains(level)
    }
    
    func unlockLevel(_ level: Int) {
        unlockedLevels.insert(level)
        saveUnlockedLevels()
    }
    
    func completeLevel(_ level: Int) {
        completedLevels.insert(level)
        saveCompletedLevels()
        
        // Unlock next level if it exists
        if level < 15 {
            unlockLevel(level + 1)
        }
    }
    
    private func saveUnlockedLevels() {
        UserDefaults.standard.set(Array(unlockedLevels), forKey: unlockedLevelsKey)
    }
    
    private func saveCompletedLevels() {
        UserDefaults.standard.set(Array(completedLevels), forKey: completedLevelsKey)
    }
    
    var totalUnlockedLevels: Int {
        unlockedLevels.count
    }
    
    var totalCompletedLevels: Int {
        completedLevels.count
    }
}
