//
//  Constants.swift
//  PepperQuest
//
//  App constants
//

import Foundation
import SwiftUI

enum Constants {
    // MARK: - App Info
    static let appName = "Pepper Quest"
    static let appVersion = "1.0.0"
    static let developerName = "Anpilogovs"
    
    // MARK: - Game Settings
    static let initialLives = 3
    static let baseSpawnInterval: TimeInterval = 1.0
    static let minSpawnInterval: TimeInterval = 0.3
    static let levelUpThreshold = 10
    
    // MARK: - Physics
    static let gravity: CGFloat = -3.0
    static let pepperSize: CGFloat = 40.0
    static let basketWidth: CGFloat = 80.0
    static let basketHeight: CGFloat = 60.0
    
    // MARK: - UI
    static let cornerRadius: CGFloat = 15.0
    static let shadowRadius: CGFloat = 5.0
    static let animationDuration: Double = 0.3
    static let buttonHeight: CGFloat = 50.0
    
    // MARK: - Colors
    static let primaryGradient = [Color.red, Color.orange]
    static let secondaryGradient = [Color.yellow, Color.orange]
    static let successColor = Color.green
    static let errorColor = Color.red
    static let warningColor = Color.orange
    
    // MARK: - Difficulty
    enum Difficulty: String, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        case extreme = "Extreme"
        var multiplier: Double {
            switch self {
            case .easy: return 0.7
            case .medium: return 1.0
            case .hard: return 1.5
            case .extreme: return 2.0
            }
        }
    }
    
    // MARK: - User Defaults Keys
    enum UserDefaultsKeys {
        static let soundEnabled = "soundEnabled"
        static let musicEnabled = "musicEnabled"
        static let hapticEnabled = "hapticEnabled"
        static let difficulty = "difficulty"
        static let playerName = "playerName"
        static let gameScores = "gameScores"
        static let highScore = "highScore"
        static let achievements = "achievements"
    }
}
