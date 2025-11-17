//
//  PepperNode.swift
//  PepperQuest
//
//  Pepper sprite node for game
//

import SpriteKit
import UIKit

class PepperNode: SKSpriteNode {
    let pepperType: PepperType
    let isGood: Bool
    
    init(type: PepperType, isGood: Bool = true) {
        self.pepperType = type
        self.isGood = isGood
        
        let size = CGSize(width: 40, height: 40)
        let color = isGood ? type.uiColor : UIColor.black
        
        super.init(texture: nil, color: color, size: size)
        
        setupAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        // Add emoji label
        let label = SKLabelNode(text: isGood ? "🌶️" : "💀")
        label.fontSize = 35
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 0)
        addChild(label)
        
        // Add glow effect for extreme peppers
        if pepperType == .extreme && isGood {
            let glow = SKSpriteNode(color: .clear, size: CGSize(width: 50, height: 50))
            glow.alpha = 0.3
            glow.zPosition = -1
            addChild(glow)
            
            let pulse = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.5, duration: 0.5),
                SKAction.fadeAlpha(to: 0.1, duration: 0.5)
            ])
            glow.run(SKAction.repeatForever(pulse))
        }
    }
}

// Extension to convert PepperType to UIColor
extension PepperType {
    var uiColor: UIColor {
        switch self {
        case .mild: return UIColor.clear
        case .medium: return UIColor.clear
        case .hot: return UIColor.clear
        case .extraHot: return UIColor.clear
        case .extreme: return UIColor.clear
        }
    }
}
