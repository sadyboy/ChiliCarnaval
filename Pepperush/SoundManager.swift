//
//  SoundManager.swift
//  PepperQuest
//
//  Sound effects manager
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    private init() {}
    
    func playSound(named: String) {
        // Play system sound as fallback
        AudioServicesPlaySystemSound(1103) // Pop sound
    }
    
    func playCollectSound() {
        AudioServicesPlaySystemSound(1103) // Pop
    }
    
    func playHitSound() {
        AudioServicesPlaySystemSound(1053) // Tock
    }
    
    func playGameOverSound() {
        AudioServicesPlaySystemSound(1005) // Alert
    }
}
