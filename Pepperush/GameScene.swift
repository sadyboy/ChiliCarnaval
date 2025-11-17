
import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewModel: GameViewModel?
    
    private var basket: SKSpriteNode!
    private var centerImage: SKSpriteNode!
    private var spawnTimer: Timer?
    private var lastUpdateTime: TimeInterval = 0
    private var basketMovementDirection: CGFloat = 1.0 // 1 for clockwise, -1 for counter-clockwise
    private var gameTimer: Timer?
    private var timeRemaining: Int = 60 // 60 seconds game time
    
    private let pepperCategory: UInt32 = 0x1 << 0
    private let basketCategory: UInt32 = 0x1 << 1
    private let badItemCategory: UInt32 = 0x1 << 2
    private let centerImageCategory: UInt32 = 0x1 << 3
    
    override func didMove(to view: SKView) {
        setupScene()
        setupCenterImage()
        setupBasket()
        startGameTimer()
        startSpawning()
    }
    
    func setupScene() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
         physicsWorld.contactDelegate = self

         let background = SKSpriteNode(imageNamed: "skyBackground")
         background.position = CGPoint(x: size.width / 2, y: size.height / 2)
         background.size = self.size
         background.zPosition = -1
         addChild(background)
        
        // Add border physics
        setupBorderPhysics()
    }
    
    func setupBorderPhysics() {
        let border = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        border.friction = 0
        border.restitution = 0.6
        physicsBody = border
    }
    
    func setupCenterImage() {
        // Central emoji image
        centerImage = SKSpriteNode(color: .clear, size: CGSize(width: 120, height: 120))
        centerImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Add emoji label
        let basketTexture = SKTexture(imageNamed: "basket")
        let basketImage = SKSpriteNode(texture: basketTexture)
        basketImage.size = CGSize(width: 100, height: 100)
        basketImage.position = CGPoint(x: 0, y: -15)
        centerImage.addChild(basketImage)
        
        // Add pulsing animation to center image
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.5),
            SKAction.scale(to: 1.0, duration: 0.5)
        ])
        centerImage.run(SKAction.repeatForever(pulse))
        
        addChild(centerImage)
    }
    
    func setupBasket() {
        basket = SKSpriteNode(color: .clear, size: CGSize(width: 80, height: 60))
        basket.position = CGPoint(x: size.width / 2, y: 80) // Start at bottom center
        basket.physicsBody = SKPhysicsBody(rectangleOf: basket.size)
        basket.physicsBody?.isDynamic = false
        basket.physicsBody?.categoryBitMask = basketCategory
        basket.physicsBody?.contactTestBitMask = pepperCategory | badItemCategory
        basket.name = "basket"
        addChild(basket)
        
        // Add basket label
        let label = SKLabelNode(text: "🧺")
        label.fontSize = 50
        label.position = CGPoint(x: 0, y: -15)
        basket.addChild(label)
        
        // Start moving around the perimeter
        startBasketMovement()
    }
    
    func startBasketMovement() {
        basket.removeAllActions()
        
        let moveSpeed: Double = 2.5 / (viewModel?.difficultyMultiplier ?? 1.0)
        
        // Create path around perimeter
        let path = CGMutablePath()
        if basketMovementDirection > 0 {
            // Clockwise
            path.move(to: CGPoint(x: 50, y: 80))
            path.addLine(to: CGPoint(x: size.width - 50, y: 80))
            path.addLine(to: CGPoint(x: size.width - 50, y: size.height - 80))
            path.addLine(to: CGPoint(x: 50, y: size.height - 80))
            path.closeSubpath()
        } else {
            // Counter-clockwise
            path.move(to: CGPoint(x: 50, y: 80))
            path.addLine(to: CGPoint(x: 50, y: size.height - 80))
            path.addLine(to: CGPoint(x: size.width - 50, y: size.height - 80))
            path.addLine(to: CGPoint(x: size.width - 50, y: 80))
            path.closeSubpath()
        }
        
        let followPath = SKAction.follow(path, asOffset: false, orientToPath: false, duration: moveSpeed * 4)
        let continuousMovement = SKAction.repeatForever(followPath)
        basket.run(continuousMovement)
    }
    
    func toggleBasketDirection() {
        basketMovementDirection *= -1
        startBasketMovement()
        
        // Visual feedback for direction change
        let flash = SKAction.sequence([
            SKAction.colorize(with: .yellow, colorBlendFactor: 0.5, duration: 0.1),
            SKAction.colorize(with: .clear, colorBlendFactor: 0, duration: 0.1)
        ])
        basket.run(flash)
    }
    
    func startGameTimer() {
        timeRemaining = 60
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    func updateTimer() {
        timeRemaining -= 1
        viewModel?.timeRemaining = timeRemaining
        
        if timeRemaining <= 0 {
            gameTimer?.invalidate()
            viewModel?.endGame()
        }
    }
    
    func startSpawning() {
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.spawnPepper()
        }
    }
    
    func spawnPepper() {
        guard let viewModel = viewModel, !viewModel.isPaused, !viewModel.isGameOver else { return }
        
        let pepperTypes = PepperType.allCases
        let randomType = pepperTypes.randomElement() ?? .medium
        
        // 80% chance for good pepper, 20% for bad item
        let isGood = Double.random(in: 0...1) < 0.8
        
        let pepper = PepperNode(type: randomType, isGood: isGood)
        
        // Spawn from center image position
        pepper.position = centerImage.position
        
        let difficulty = viewModel.difficultyMultiplier
        
        // Physics body
        pepper.physicsBody = SKPhysicsBody(circleOfRadius: pepper.size.width / 2)
        pepper.physicsBody?.categoryBitMask = isGood ? pepperCategory : badItemCategory
        pepper.physicsBody?.contactTestBitMask = basketCategory
        pepper.physicsBody?.collisionBitMask = 0xFFFFFFFF // Collide with everything
        pepper.physicsBody?.linearDamping = 0.05
        pepper.physicsBody?.angularDamping = 0.1
        pepper.physicsBody?.restitution = 0.7 // Bounciness
        
        // Apply velocity in random direction from center - FIXED VERSION
        let angle = CGFloat.random(in: 0...(2 * .pi))
        let speed = CGFloat.random(in: 200...400) * difficulty
        
        // Explicitly convert to Double for cos/sin, then back to CGFloat
        let dx = CGFloat(cos(Double(angle))) * speed
        let dy = CGFloat(sin(Double(angle))) * speed
        
        pepper.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        
        // Apply random angular velocity for spinning
        pepper.physicsBody?.angularVelocity = CGFloat.random(in: -5...5)
        
        addChild(pepper)
        
        // Remove after timeout
        let removeAction = SKAction.sequence([
            SKAction.wait(forDuration: 6.0),
            SKAction.removeFromParent()
        ])
        pepper.run(removeAction)
        
        // Add spawn effect from center
        showSpawnEffect(at: centerImage.position)
    }
    
    func showSpawnEffect(at position: CGPoint) {
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.3, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])
        centerImage.run(pulse)
        
        // Ring effect
        let ring = SKShapeNode(circleOfRadius: 20)
        ring.strokeColor = .white
        ring.lineWidth = 3
        ring.fillColor = .clear
        ring.position = position
        ring.alpha = 0.8
        
        addChild(ring)
        
        let expand = SKAction.group([
            SKAction.scale(to: 3.0, duration: 0.3),
            SKAction.fadeOut(withDuration: 0.3)
        ])
        let remove = SKAction.removeFromParent()
        
        ring.run(SKAction.sequence([expand, remove]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else { return }
        
        // Toggle basket direction on any tap
        toggleBasketDirection()
        
        // Visual feedback for tap
        let tapNode = SKShapeNode(circleOfRadius: 10)
        tapNode.fillColor = .white
        tapNode.strokeColor = .clear
        tapNode.alpha = 0.5
        
        if let touch = touches.first {
            tapNode.position = touch.location(in: self)
        } else {
            tapNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        }
        
        addChild(tapNode)
        
        let fadeOut = SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 2.0, duration: 0.3),
                SKAction.fadeOut(withDuration: 0.3)
            ]),
            SKAction.removeFromParent()
        ])
        
        tapNode.run(fadeOut)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let viewModel = viewModel else { return }
        
        if viewModel.isPaused || viewModel.isGameOver {
            spawnTimer?.invalidate()
            gameTimer?.invalidate()
            basket.removeAllActions()
        } else if spawnTimer == nil || !(spawnTimer?.isValid ?? false) {
            startSpawning()
            startBasketMovement()
        }
        
        // Adjust spawn rate based on level
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        let deltaTime = currentTime - lastUpdateTime
        if deltaTime > 1.0 {
            lastUpdateTime = currentTime
        }
        
        // Keep basket upright
        basket.zRotation = 0
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == pepperCategory | basketCategory {
            let pepperNode = (contact.bodyA.node as? PepperNode) ?? (contact.bodyB.node as? PepperNode)
            
            if let pepper = pepperNode, pepper.isGood {
                collectPepper(pepper)
            }
        } else if collision == badItemCategory | basketCategory {
            let badNode = (contact.bodyA.node as? PepperNode) ?? (contact.bodyB.node as? PepperNode)
            
            if let bad = badNode, !bad.isGood {
                collectBadItem(bad)
            }
        }
    }
    
    func collectPepper(_ pepper: PepperNode) {
        // Particle effect
        showCollectionEffect(at: pepper.position, isGood: true)
        
        // Update score
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.collectPepper(type: pepper.pepperType)
        }
        
        // Remove pepper
        pepper.removeFromParent()
        
        // Play sound effect
        run(SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false))
        
        // Bounce effect on basket
        let bounce = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])
        basket.run(bounce)
    }
    
    func collectBadItem(_ badItem: PepperNode) {
        // Particle effect
        showCollectionEffect(at: badItem.position, isGood: false)
        
        // Lose life
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.collectBadItem()
        }
        
        // Remove item
        badItem.removeFromParent()
        
        // Shake effect
        let shake = SKAction.sequence([
            SKAction.moveBy(x: -15, y: 0, duration: 0.05),
            SKAction.moveBy(x: 30, y: 0, duration: 0.05),
            SKAction.moveBy(x: -15, y: 0, duration: 0.05)
        ])
        basket.run(shake)
    }
    
    func showCollectionEffect(at position: CGPoint, isGood: Bool) {
        let particleCount = 25
        
        for _ in 0..<particleCount {
            let particle = SKShapeNode(circleOfRadius: 3)
            particle.fillColor = isGood ? .systemYellow : .systemRed
            particle.strokeColor = .clear
            particle.position = position
            
            addChild(particle)
            
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let distance = CGFloat.random(in: 30...100)
            let dx = cos(Double(angle)) * Double(distance)
            let dy = sin(Double(angle)) * Double(distance)
            
            let move = SKAction.moveBy(x: CGFloat(dx), y: CGFloat(dy), duration: 0.6)
            let fade = SKAction.fadeOut(withDuration: 0.6)
            let scale = SKAction.scale(to: 0.1, duration: 0.6)
            let group = SKAction.group([move, fade, scale])
            let remove = SKAction.removeFromParent()
            
            particle.run(SKAction.sequence([group, remove]))
        }
        
        // Show score label
        let scoreLabel = SKLabelNode(text: isGood ? "+\(PepperType.allCases.randomElement()?.points ?? 10)" : "-❤️")
        scoreLabel.position = position
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = isGood ? .systemYellow : .systemRed
        scoreLabel.fontName = "PeppaBold"
        
        addChild(scoreLabel)
        
        let moveUp = SKAction.moveBy(x: 0, y: 60, duration: 0.8)
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        let scaleUp = SKAction.scale(to: 1.3, duration: 0.8)
        let group = SKAction.group([moveUp, fadeOut, scaleUp])
        let removeLabel = SKAction.removeFromParent()
        
        scoreLabel.run(SKAction.sequence([group, removeLabel]))
    }
    
    deinit {
        spawnTimer?.invalidate()
        gameTimer?.invalidate()
    }
}
