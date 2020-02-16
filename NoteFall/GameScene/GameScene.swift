import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    fileprivate var gameOverScene: GameOverScene!
    
    fileprivate let microphoneManager = MicrophoneManager.shared
    fileprivate let gameManager = GameManager.shared
    
    fileprivate var gameStarted = false
    
    fileprivate var isPlaying = false
    fileprivate let tolerance = 0.95
    
    fileprivate var noteSpeed: CGFloat = 1
    fileprivate let speedIncrease: CGFloat = 0.5
    
    fileprivate var numberOfLives = 3
    
    fileprivate var notes: [Note]!
    
    fileprivate var note: Note!
    
    fileprivate var lifeNodes = [SKNode]()
    
    fileprivate var backgroundNode: SKSpriteNode!
    
    fileprivate let noteLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontColor = .orange
        label.fontSize = 48
        label.fontName = "HelveticaNeue-Medium"
        return label
    }()
    
    fileprivate var count = 4 {
        didSet {
            countdownLabel.text = String(count)
        }
    }
    fileprivate lazy var countdownLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontSize = 96
        label.fontName = "HelveticaNeue-Medium"
        label.fontColor = .orange
        return label
    }()
    
    fileprivate var score = 0
    fileprivate let scoreTitle = ScoreLabel(text: "Score", fontSize: 24)
    fileprivate let scoreLabel = ScoreLabel(text: "0", fontSize: 36)
    
    fileprivate let highscoreTitle = ScoreLabel(text: "Highscore", fontSize: 24)
    fileprivate let highscoreLabel = ScoreLabel(text: String(UserDefaults.standard.integer(forKey: Defaults.highscore)), fontSize: 36)
    
    fileprivate var transposition: Transposition!
    fileprivate var transpositionFactor: Double = 1
    
    override func didMove(to view: SKView) {
        
        transposition = Transposition(rawValue: gameManager.transposition)
        
        backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode.size.height = view.frame.height
        backgroundNode.position = view.center
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        notes = Note.naturalNotes
        if gameManager.useAccidentals {
            notes += Note.flatNotes
            notes += Note.sharpNotes
        }
        
        switch transposition {
        case .C:
            transpositionFactor = 1
        case .Bb:
            transpositionFactor = 130.81 / 146.83
        case .Eb:
            transpositionFactor = 116.54 / 196.00
        case .F:
            transpositionFactor = 130.31 / 196.00
        case .none:
            transpositionFactor = 1
        }
        
        createHapticFeedback(style: .light)
        
        microphoneManager.setupMicrophone()
        highscoreTitle.position = CGPoint(x: 70, y: frame.height - 60)
        addChild(highscoreTitle)
        highscoreLabel.position = CGPoint(x: 70, y: frame.height - 110)
        addChild(highscoreLabel)
        scoreTitle.position = CGPoint(x: 70, y: frame.height - 180)
        addChild(scoreTitle)
        scoreLabel.position = CGPoint(x: 70, y: frame.height - 230)
        addChild(scoreLabel)
        
        for i in 1...numberOfLives {
            let lifeNode = SKSpriteNode(imageNamed: "Heart")
            lifeNode.name = "Life\(i)"
            lifeNode.setScale(0.3)
            lifeNode.position = CGPoint(x: frame.maxX - 60, y: frame.maxY - 60*CGFloat(i) - 20)
            lifeNodes.append(lifeNode)
            addChild(lifeNode)
        }
        
        if !gameStarted {
            
            countdownLabel.position = view.center
            addChild(countdownLabel)
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                self.count -= 1
                if self.count <= 0 {
                    self.startGame()
                    self.countdownLabel.removeFromParent()
                    timer.invalidate()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameStarted {
            noteLabel.position.y -= noteSpeed
            if microphoneManager.tracker.amplitude > 0.3 {
                if isPlaying { return }
                
                for i in octaves {
                    let upperLimit = ((note.frequency*i)*transpositionFactor) * (1+(1-tolerance))
                    let lowerLimit = ((note.frequency*i)*transpositionFactor) * tolerance
                    if microphoneManager.tracker.frequency < upperLimit && microphoneManager.tracker.frequency > lowerLimit {
                        incrementScore(by: 1)
                        isPlaying = true
                        destroy(noteLabel)
                        spawnNote()
                        
                        return
                    }
                }
            } else {
                isPlaying = false
            }
            
            if noteLabel.position.y < -20 {
                decreaseLife()
            }
            
            if numberOfLives <= 0 {
                endGame()
            }
        }
    }
    
    fileprivate func spawnNote() {
        note = notes.randomElement()!
        let animationDuration: Double = 1.4
        let initialRotation: CGFloat = .pi * 0.9
        noteLabel.position = CGPoint(x: frame.midX, y: frame.maxY)
        noteLabel.zRotation = CGFloat.random(in: -initialRotation...(initialRotation))
        let anim1 = SKAction.rotate(toAngle: .pi/5, duration: animationDuration)
        let anim2 = SKAction.rotate(toAngle: -.pi/5, duration: animationDuration)
        noteLabel.text = note.name
        let rotationAnimation = SKAction.sequence([anim1, anim2])
        let foreverAnimation = SKAction.repeatForever(rotationAnimation)
        noteLabel.run(foreverAnimation)
        addChild(noteLabel)
    }
    
    fileprivate func destroy(_ node: SKNode) {
        
        if let particles = SKEmitterNode(fileNamed: "explosion.sks") {
            particles.position = node.position
            addChild(particles)
        }
        
        node.removeFromParent()
        node.removeAllActions()
    }
    
    fileprivate func incrementScore(by increment: Int) {
        score += increment
        if score % 10 == 0 {
            noteSpeed += speedIncrease
        }
        scoreLabel.text = String(score)
        if score > gameManager.highscore {
            gameManager.highscore = score
            highscoreLabel.text = String(gameManager.highscore)
            UserDefaults.standard.set(gameManager.highscore, forKey: Defaults.highscore)
            UserDefaults.standard.synchronize()
        }
    }
    
    fileprivate func decreaseLife() {
        numberOfLives -= 1
        destroy(noteLabel)
        lifeNodes.last?.removeFromParent()
        lifeNodes.removeLast()
        spawnNote()
    }
    
    fileprivate func startGame() {
        gameStarted = true
        spawnNote()
    }
    
    fileprivate func endGame() {
        gameStarted = false
        
        microphoneManager.stop()
        
        createHapticFeedback(style: .heavy)
        
        if Device.isIpad {
            gameOverScene = GameOverScene(fileNamed: "GameOverScenePad.sks")
        } else if Device.hasNotch {
            gameOverScene = GameOverScene(fileNamed: "GameOverSceneNotch.sks")
        } else {
            gameOverScene = GameOverScene(fileNamed: "GameOverScene.sks")
        }
        
        gameOverScene.score = score
        gameOverScene.scaleMode = .aspectFill
        view?.presentScene(gameOverScene)
    }
}
