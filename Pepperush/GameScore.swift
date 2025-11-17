//
//  GameScore.swift
//  PepperQuest
//
//  Game score model
//

import Foundation

struct GameScore: Identifiable, Codable {
    let id: UUID
    let playerName: String
    let score: Int
    let level: Int
    let date: Date
    let peppersCollected: Int
    
    init(id: UUID = UUID(), playerName: String, score: Int, level: Int, date: Date = Date(), peppersCollected: Int) {
        self.id = id
        self.playerName = playerName
        self.score = score
        self.level = level
        self.date = date
        self.peppersCollected = peppersCollected
    }
}
