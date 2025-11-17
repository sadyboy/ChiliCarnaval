//
//  LeaderboardViewModel.swift
//  PepperQuest
//
//  MVVM - Leaderboard logic
//

import Foundation
import Combine
import SwiftUI

class LeaderboardViewModel: ObservableObject {
    @Published var scores: [GameScore] = []
    @Published var sortOption: SortOption = .score
    @Published var showClearConfirmation = false
    @Published var playerName: String = "Player"
    
    private let dataManager = DataManager.shared
    
    enum SortOption: String, CaseIterable {
        case score = "Score"
        case level = "Level"
        case date = "Date"
        case peppers = "Peppers"
        
        var icon: String {
            switch self {
            case .score: return "star.fill"
            case .level: return "arrow.up.circle.fill"
            case .date: return "calendar"
            case .peppers: return "leaf.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .score: return .yellow
            case .level: return .blue
            case .date: return .purple
            case .peppers: return .green
            }
        }
    }
    
    init() {
        loadScores()
        loadPlayerName()
    }
    
    func loadScores() {
        scores = dataManager.getAllScores()
        sortScores()
    }
    
    func sortScores() {
        switch sortOption {
        case .score:
            scores.sort { $0.score > $1.score }
        case .level:
            scores.sort { $0.level > $1.level }
        case .date:
            scores.sort { $0.date > $1.date }
        case .peppers:
            scores.sort { $0.peppersCollected > $1.peppersCollected }
        }
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
        
        // Update all scores with new player name
        updateAllScoresWithNewName(finalName)
    }
    
    private func updateAllScoresWithNewName(_ newName: String) {
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
        loadScores() // Reload to reflect changes
    }
    
    func deleteScore(_ score: GameScore) {
        dataManager.deleteScore(score)
        loadScores()
    }
    
    func clearAllScores() {
        dataManager.clearAllScores()
        loadScores()
        showClearConfirmation = false
    }
    
    var topScore: GameScore? {
        scores.first
    }
    
    var averageScore: Int {
        guard !scores.isEmpty else { return 0 }
        let total = scores.reduce(0) { $0 + $1.score }
        return total / scores.count
    }
}
