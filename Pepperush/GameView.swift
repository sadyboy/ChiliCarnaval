
import SwiftUI
import SpriteKit


// MARK: - Updated GameView to include Level Selection
struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showGameOver = false
    @State private var showLevelSelection = true // Show level selection first
    @State private var selectedLevel = 1
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            if showLevelSelection {
                LevelSelectionView(
                    onBack: onBack,
                    onLevelSelected: { level in
                        selectedLevel = level
                        showLevelSelection = false
                        viewModel.startNewGame(level: level)
                    }
                )
            } else {
                // Original game view
                SpriteView(scene: createGameScene())
                    .ignoresSafeArea()
                
                // HUD Overlay and other game UI...
                gameHUDView
                
                if viewModel.isPaused && !viewModel.isGameOver {
                    pauseOverlayView
                }
                
                if viewModel.isGameOver {
                    gameOverOverlayView
                }
            }
        }
    }
    
    // MARK: - Game HUD View
    private var gameHUDView: some View {
        VStack {
            // Top HUD
            HStack {
                Button(action: {
                    showLevelSelection = true
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(backButtonGradient)
                        .clipShape(Circle())
                        .shadow(color: .orange.opacity(0.4), radius: 3, x: 0, y: 2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Level: \(selectedLevel)")
                        .font(.custom("PeppaBold", size: 16))
                        .foregroundColor(getLevelColor(selectedLevel))
                    Text("Score: \(viewModel.score)")
                        .font(.custom("PeppaBold", size: 17))
                    Text("Time: \(viewModel.timeRemaining)s")
                        .font(.custom("PeppaBold", size: 15))
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                
                Spacer()
                
                Button(action: { viewModel.togglePause() }) {
                    Image(systemName: viewModel.isPaused ? "play.circle.fill" : "pause.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(backButtonGradient)
                        .clipShape(Circle())
                        .shadow(color: .orange.opacity(0.4), radius: 3, x: 0, y: 2)
                }
            }
            .padding()
            
            Spacer()
            
            // Bottom HUD (lives and peppers)
            HStack(spacing: 20) {
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Image(systemName: index < viewModel.lives ? "heart.fill" : "heart")
                            .foregroundColor(index < viewModel.lives ? .red : .gray)
                            .font(.custom("PeppaBold", size: 22))
                    }
                }
                .padding(10)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text("🌶️")
                        .font(.custom("PeppaBold", size: 22))
                    Text("\(viewModel.peppersCollected)")
                        .font(.headline.bold())
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    // MARK: - Pause Overlay View
    private var pauseOverlayView: some View {
        Color.black.opacity(0.7)
            .ignoresSafeArea()
        
        return VStack(spacing: 30) {
            Text("PAUSE")
                .font(.custom("PeppaBold", size: 50))
                .foregroundColor(.white)
            
            Button(action: { viewModel.togglePause() }) {
                Text("Continue")
                    .font(.custom("PeppaBold", size: 22))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
            }
            
            Button(action: {
                viewModel.startNewGame(level: selectedLevel)
            }) {
                Text("Restart Level")
                    .font(.custom("PeppaBold", size: 22))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(15)
            }
            
            Button(action: {
                showLevelSelection = true
            }) {
                Text("Level Selection")
                    .font(.custom("PeppaBold", size: 22))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            
            Button(action: onBack) {
                Text("Main Menu")
                    .font(.custom("PeppaBold", size: 22))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(15)
            }
        }
    }
    
    // MARK: - Game Over Overlay View
    private var gameOverOverlayView: some View {
        Color.black.opacity(0.8)
            .ignoresSafeArea()
        
        return VStack(spacing: 20) {
            Text("LEVEL \(selectedLevel) COMPLETE!")
                .font(.custom("PeppaBold", size: 32))
                .foregroundColor(getLevelColor(selectedLevel))
            
            VStack(spacing: 10) {
                Text("Score: \(viewModel.score)")
                    .font(.custom("PeppaBold", size: 28))
                Text("Peppers: \(viewModel.peppersCollected)")
                    .font(.custom("PeppaBold", size: 22))
                Text("Time: \(60 - viewModel.timeRemaining)s")
                    .font(.custom("PeppaBold", size: 22))
            }
            .foregroundColor(.white)
            
            if viewModel.score == viewModel.highScore && viewModel.score > 0 {
                Text("🏆 NEW HIGH SCORE! 🏆")
                    .font(.custom("PeppaBold", size: 22))
                    .foregroundColor(.yellow)
            }
            
            Button(action: {
                // Complete the level and start next one
                completeCurrentLevel()
                let nextLevel = selectedLevel + 1
                if nextLevel <= 15 {
                    selectedLevel = nextLevel
                    viewModel.startNewGame(level: nextLevel)
                } else {
                    showLevelSelection = true
                }
            }) {
                Text(selectedLevel < 15 ? "Next Level" : "Back to Levels")
                    .font(.custom("PeppaBold", size: 22))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
            }
            
            Button(action: {
                viewModel.startNewGame(level: selectedLevel)
            }) {
                Text("Play Again")
                    .font(.custom("PeppaBold", size: 22))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(15)
            }
            
            Button(action: {
                showLevelSelection = true
            }) {
                Text("Level Selection")
                    .font(.custom("PeppaBold", size: 22))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
            }
        }
        .padding()
    }
    
    private func completeCurrentLevel() {
        // Save level completion
        let levelVM = LevelSelectionViewModel()
        levelVM.loadUnlockedLevels()
        levelVM.completeLevel(selectedLevel)
    }
    
    private func getLevelColor(_ level: Int) -> Color {
        switch level {
        case 1...5: return .green
        case 6...10: return .yellow
        case 11...15: return .red
        default: return .blue
        }
    }
    
    private var backButtonGradient: LinearGradient {
        LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
    }
    
    func createGameScene() -> SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        scene.viewModel = viewModel
        return scene
    }
}

// MARK: - Updated GameViewModel for Level Support
extension GameViewModel {
    func startNewGame(level: Int = 1) {
        score = 0
        lives = 3
        self.level = level // Use the selected level
        isPaused = false
        isGameOver = false
        peppersCollected = 0
        timeRemaining = 60
        
        // Adjust game difficulty based on level
        applyLevelDifficulty(level)
    }
    
    private func applyLevelDifficulty(_ level: Int) {
        // Adjust game parameters based on level
        // This will be used by the GameScene to modify spawn rates, speeds, etc.
        switch level {
        case 1:
            // Easy - slow spawn, mostly good peppers
            break
        case 2, 3:
            // Medium - faster spawn
            break
        case 4, 5:
            // Hard - even faster, more bad items
            break
        case 6...10:
            // Very hard - high speed, many bad items
            break
        case 11...15:
            // Extreme - maximum difficulty
            break
        default:
            break
        }
    }

}
