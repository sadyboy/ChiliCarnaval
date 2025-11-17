//
//  ProfileViewModel.swift
//  PepperQuest
//
//  MVVM - Profile logic
//

import Foundation
import Combine
import SwiftUI
import UIKit

class ProfileViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var totalScore: Int = 0
    @Published var totalPeppers: Int = 0
    @Published var gamesPlayed: Int = 0
    @Published var highScore: Int = 0
    @Published var playerLevel: Int = 1
    @Published var winRate: Int = 0
    @Published var playTime: Int = 0
    @Published var averageScore: Int = 0
    @Published var playerName: String = "Player"
    @Published var profileImage: UIImage?
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadProfile()
        subscribeToUpdates()
        loadPlayerName()
        loadProfileImage()
    }
    
    func loadProfile() {
        achievements = dataManager.getAchievements()
        let scores = dataManager.getAllScores()
        
        totalScore = dataManager.totalScore
        totalPeppers = dataManager.totalPeppersCollected
        gamesPlayed = dataManager.gamesPlayed
        highScore = dataManager.getHighScore()
        
        // Calculate additional stats
        calculateAdditionalStats(scores: scores)
    }
    
    private func calculateAdditionalStats(scores: [GameScore]) {
        // Calculate player level based on total score
        playerLevel = max(1, totalScore / 1000)
        
        // Calculate win rate (assuming score > 0 is a win)
        let wins = scores.filter { $0.score > 0 }.count
        winRate = gamesPlayed > 0 ? Int(Double(wins) / Double(gamesPlayed) * 100) : 0
        
        // Calculate average score
        averageScore = gamesPlayed > 0 ? totalScore / gamesPlayed : 0
        
        // Calculate play time (estimated based on games played)
        playTime = gamesPlayed * 5 // assuming 5 minutes per game
    }
    
    // MARK: - Player Name Management
    
    func loadPlayerName() {
        playerName = UserDefaults.standard.string(forKey: "playerName") ?? "Player"
    }
    
    func savePlayerName(_ name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = trimmedName.isEmpty ? "Player" : trimmedName
        
        playerName = finalName
        UserDefaults.standard.set(finalName, forKey: "playerName")
        
        // Update all existing scores with new name
        updateScoresWithNewName(finalName)
    }
    
    private func updateScoresWithNewName(_ newName: String) {
        var updatedScores = dataManager.getAllScores()
        for i in 0..<updatedScores.count {
            updatedScores[i] = GameScore(
                id: updatedScores[i].id,
                playerName: newName,
                score: updatedScores[i].score,
                level: updatedScores[i].level,
                date: updatedScores[i].date,
                peppersCollected: updatedScores[i].peppersCollected
            )
        }
        dataManager.updateAllScores(updatedScores)
    }
    
    // MARK: - Profile Image Management
    func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImage"),
           let image = UIImage(data: imageData) {
            profileImage = image
        }
    }
    
    func saveProfileImage(_ imageData: Data) {
        UserDefaults.standard.set(imageData, forKey: "profileImage")
        if let image = UIImage(data: imageData) {
            profileImage = image
        }
    }
    
    func deleteProfileImage() {
        UserDefaults.standard.removeObject(forKey: "profileImage")
        profileImage = nil
    }
    
    private func subscribeToUpdates() {
        // Subscribe to achievement updates
        dataManager.achievementsPublisher
            .sink { [weak self] achievements in
                self?.achievements = achievements
            }
            .store(in: &cancellables)
        
        // Subscribe to score updates
        dataManager.scoresPublisher
            .sink { [weak self] _ in
                self?.loadProfile()
            }
            .store(in: &cancellables)
    }
    
    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }
    }
    
    var lockedAchievements: [Achievement] {
        achievements.filter { !$0.isUnlocked }
    }
    
    var completionPercentage: Double {
        guard !achievements.isEmpty else { return 0 }
        let unlocked = Double(unlockedAchievements.count)
        let total = Double(achievements.count)
        return (unlocked / total) * 100
    }
}
