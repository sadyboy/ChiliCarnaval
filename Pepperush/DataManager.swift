//
//  DataManager.swift
//  PepperQuest
//
//  Data persistence manager
//

import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var achievements: [Achievement] = []
    @Published var gameScores: [GameScore] = []
    
    private let scoresKey = "gameScores"
    private let highScoreKey = "highScore"
    private let achievementsKey = "achievements"
    
    private init() {
        loadGameScores()
        loadAchievements()
    }
    
    // MARK: - Scores
    
    func saveScore(_ score: GameScore) {
        gameScores.append(score)
        saveGameScores()
        
        // Update high score if needed
        if score.score > getHighScore() {
            saveHighScore(score.score)
        }
        
        // Update achievements
        updateAchievements()
    }
    
    func getAllScores() -> [GameScore] {
        return gameScores
    }
    
    func deleteScore(_ score: GameScore) {
        gameScores.removeAll { $0.id == score.id }
        saveGameScores()
    }
    
    func clearAllScores() {
        gameScores.removeAll()
        saveGameScores()
        saveHighScore(0)
    }
    
    private func loadGameScores() {
        guard let data = UserDefaults.standard.data(forKey: scoresKey),
              let scores = try? JSONDecoder().decode([GameScore].self, from: data) else {
            return
        }
        gameScores = scores
    }
    
    private func saveGameScores() {
        if let encoded = try? JSONEncoder().encode(gameScores) {
            UserDefaults.standard.set(encoded, forKey: scoresKey)
        }
    }
    
    // MARK: - High Score
    
    func saveHighScore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: highScoreKey)
    }
    
    func getHighScore() -> Int {
        return UserDefaults.standard.integer(forKey: highScoreKey)
    }
    
    // MARK: - Achievements
    
    private func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let saved = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = saved
        } else {
            achievements = getDefaultAchievements()
            saveAchievements()
        }
    }
    
    func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: achievementsKey)
        }
    }
    
    func getAchievements() -> [Achievement] {
        return achievements
    }
    
    private func getDefaultAchievements() -> [Achievement] {
        return [
            Achievement(
                title: "First Steps",
                description: "Play your first game",
                icon: "🎮",
                requirement: 1,
                progress: min(gamesPlayed, 1)
            ),
            Achievement(
                title: "Spice Collector",
                description: "Collect 10 peppers",
                icon: "🌶️",
                requirement: 10,
                progress: min(totalPeppersCollected, 10)
            ),
            Achievement(
                title: "High Scorer",
                description: "Reach 1000 points",
                icon: "🏆",
                requirement: 1000,
                progress: min(getHighScore(), 1000)
            ),
            Achievement(
                title: "Addicted",
                description: "Play 10 games",
                icon: "🔥",
                requirement: 10,
                progress: min(gamesPlayed, 10)
            ),
            Achievement(
                title: "Master Collector",
                description: "Collect 50 peppers",
                icon: "⭐",
                requirement: 50,
                progress: min(totalPeppersCollected, 50)
            ),
            Achievement(
                title: "Ultimate Champion",
                description: "Reach 5000 points",
                icon: "👑",
                requirement: 5000,
                progress: min(getHighScore(), 5000)
            ),
            Achievement(
                title: "Level Master",
                description: "Reach level 5",
                icon: "🚀",
                requirement: 5,
                progress: min(highestLevel, 5)
            ),
            Achievement(
                title: "Perfect Game",
                description: "Score over 2000 points",
                icon: "💎",
                requirement: 2000,
                progress: min(getHighScore(), 2000)
            )
        ]
    }
    func updateAchievements(peppersCollected: Int, score: Int) {
           // Create updated achievements with current stats
           let updatedAchievements = getDefaultAchievements()
           
           // Preserve unlock status and update progress
           var finalAchievements: [Achievement] = []
           
           for newAchievement in updatedAchievements {
               var finalAchievement = newAchievement
               
               // Find if this achievement was previously unlocked
               if let oldAchievement = achievements.first(where: { $0.id == newAchievement.id }) {
                   // Preserve unlock status
                   finalAchievement.isUnlocked = oldAchievement.isUnlocked
                   
                   // For certain achievement types, we might want to accumulate progress
                   if finalAchievement.title.contains("Collect") || finalAchievement.title.contains("peppers") {
                       // For collection achievements, use the accumulated total
                       finalAchievement.progress = totalPeppersCollected
                   } else if finalAchievement.title.contains("Score") || finalAchievement.title.contains("points") {
                       // For score achievements, use the highest score
                       finalAchievement.progress = max(finalAchievement.progress, getHighScore())
                   }
                   
                   // Check if achievement should be unlocked with new progress
                   if !finalAchievement.isUnlocked && finalAchievement.progress >= finalAchievement.requirement {
                       finalAchievement.isUnlocked = true
                       print("🏆 Achievement Unlocked: \(finalAchievement.title)")
                   }
               }
               
               finalAchievements.append(finalAchievement)
           }
           
           achievements = finalAchievements
           saveAchievements()
       }
    
    func updateAchievements() {
        let updatedAchievements = getDefaultAchievements()
        
        // Preserve unlock status
        for i in 0..<updatedAchievements.count {
            var newAchievement = updatedAchievements[i]
            if let oldAchievement = achievements.first(where: { $0.id == newAchievement.id }),
               oldAchievement.isUnlocked {
                newAchievement.isUnlocked = true
                // Keep the higher progress value
                newAchievement.progress = max(newAchievement.progress, oldAchievement.progress)
            }
            achievements = updatedAchievements
        }
        
        saveAchievements()
    }
    
    func resetAllData() {
        clearAllScores()
        achievements = getDefaultAchievements()
        saveAchievements()
    }
    
    // MARK: - Computed Properties for Achievements
    
    var gamesPlayed: Int {
        return gameScores.count
    }
    
    var totalPeppersCollected: Int {
        return gameScores.reduce(0) { $0 + $1.peppersCollected }
    }
    
    var highestLevel: Int {
        return gameScores.max(by: { $0.level < $1.level })?.level ?? 0
    }
    
    var totalScore: Int {
        return gameScores.reduce(0) { $0 + $1.score }
    }
}

// DataManager extensions for Profile
extension DataManager {
    
    // Publishers for Combine
    var achievementsPublisher: Published<[Achievement]>.Publisher {
        return $achievements
    }
    
    var scoresPublisher: Published<[GameScore]>.Publisher {
        return $gameScores
    }
    func updateAllScores(_ scores: [GameScore]) {
        gameScores = scores
        saveGameScores()
    }
}
