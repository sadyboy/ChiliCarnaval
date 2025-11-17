//
//  Achievement.swift
//  PepperQuest
//
//  Achievement model
//

import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let requirement: Int
    var progress: Int
    var isUnlocked: Bool
    
    init(id: String = UUID().uuidString,
         title: String,
         description: String,
         icon: String,
         requirement: Int,
         progress: Int = 0) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.requirement = requirement
        self.progress = progress
        self.isUnlocked = progress >= requirement
    }
}
