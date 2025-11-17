import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var score: Int = 0
    @Published var lives: Int = 3
    @Published var level: Int = 1
    @Published var isPaused: Bool = false
    @Published var isGameOver: Bool = false
    @Published var peppersCollected: Int = 0
    @Published var timeRemaining: Int = 60
    @Published var highScore: Int = 0
    @Published var encyclopediaPoints: Int = 0
    
    private let dataManager = DataManager.shared
    
    var difficultyMultiplier: Double {
        return Double(level) * 0.3 + 1.0
    }
    
    init() {
        loadHighScore()
        loadEncyclopediaPoints()
    }
    
    func startNewGame() {
        score = 0
        lives = 3
        level = 1
        isPaused = false
        isGameOver = false
        peppersCollected = 0
        timeRemaining = 60
    }
    
    func collectPepper(type: PepperType) {
        let points = type.points
        score += points
        peppersCollected += 1
        encyclopediaPoints += points
        
        // Level up every 500 points
        level = (score / 500) + 1
        
        // Save encyclopedia points
        saveEncyclopediaPoints()
        
        // Check for high score
        if score > highScore {
            highScore = score
            saveHighScore()
        }
    }
    
    func collectBadItem() {
        lives -= 1
        if lives <= 0 {
            endGame()
        }
    }
    
    func togglePause() {
        isPaused.toggle()
    }
    
    func endGame() {
        isGameOver = true
        isPaused = true
        
        // Save score to leaderboard
        let gameScore = GameScore(
            playerName: "Player", score: score,
            level: level,
            date: Date(), peppersCollected: peppersCollected
        )
        dataManager.saveScore(gameScore)
        
        // Update achievements
        dataManager.updateAchievements(peppersCollected: peppersCollected, score: score)
    }
    
    private func loadHighScore() {
        highScore = dataManager.getHighScore()
    }
    
    private func saveHighScore() {
        dataManager.saveHighScore(highScore)
    }
    
     func loadEncyclopediaPoints() {
        encyclopediaPoints = UserDefaults.standard.integer(forKey: "encyclopediaPoints")
    }
    
    private func saveEncyclopediaPoints() {
        UserDefaults.standard.set(encyclopediaPoints, forKey: "encyclopediaPoints")
    }
    
    func unlockEncyclopediaEntry(cost: Int) -> Bool {
        if encyclopediaPoints >= cost {
            encyclopediaPoints -= cost
            saveEncyclopediaPoints()
            return true
        }
        return false
    }
}
