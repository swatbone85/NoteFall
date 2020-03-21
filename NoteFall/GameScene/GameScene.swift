import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var gameOverScene: GameOverScene!
    private var welcomeScene: WelcomeScene!
    
    private let audioManager = AudioManager.shared
    private let gameManager = GameManager.shared
    
    private var gameStarted = false
    
    private var isPlaying = false
    
    private let tolerance = 0.95
    
    private var noteSpeed: CGFloat = 1
    private let speedIncrease: CGFloat = 0.5
    
    private var numberOfLives = 3
    
    private var note: Note!
    
    private var lifeNodes = [SKNode]()
    
    private var backgroundNode: SKSpriteNode!
    
    private var pauseButton: SKSpriteNode!
    private var exitButton: SKSpriteNode!
    
    private let noteLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontColor = .orange
        label.fontSize = 48
        label.fontName = "HelveticaNeue-Medium"
        return label
    }()
    
    private var count = 4 {
        didSet {
            countdownLabel.text = String(count)
        }
    }
    private lazy var countdownLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontSize = 96
        label.fontName = "HelveticaNeue-Medium"
        label.fontColor = .orange
        return label
    }()
    
    private var score = 0
    private var scoreTitle: ScoreLabel!
    private let scoreLabel = ScoreLabel(text: "0", fontSize: 36)
    
    private var highscoreTitle: ScoreLabel!
    private let highscoreLabel = ScoreLabel(text: String(UserDefaults.standard.integer(forKey: Defaults.highscore)), fontSize: 36)
    
    private var transposition: Transposition!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if pauseButton.contains(touch.location(in: self)) {
            didTapPause()
        } else if exitButton.contains(touch.location(in: self)) {
            didTapExit()
        }
    }
    
    override func didMove(to view: SKView) {
        createHapticFeedback(style: .light)
        
        transposition = Transposition(rawValue: gameManager.transposition)
        
        backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode.size.height = view.frame.height
        backgroundNode.position = view.center
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        scoreTitle = ScoreLabel(text: Localization.scoreLabel, fontSize: 24)
        highscoreTitle = ScoreLabel(text: Localization.highscoreLabel, fontSize: 24)
        
        highscoreTitle.position = CGPoint(x: 70, y: frame.height - 60)
        addChild(highscoreTitle)
        highscoreLabel.position = CGPoint(x: 70, y: frame.height - 110)
        addChild(highscoreLabel)
        scoreTitle.position = CGPoint(x: 70, y: frame.height - 180)
        addChild(scoreTitle)
        scoreLabel.position = CGPoint(x: 70, y: frame.height - 230)
        addChild(scoreLabel)
        
        pauseButton = SKSpriteNode(imageNamed: "Pause")
        pauseButton.position = CGPoint(x: frame.midX, y: 100)
        pauseButton.alpha = 0
        addChild(pauseButton)
        
        exitButton = SKSpriteNode(imageNamed: "Exit")
        exitButton.position = CGPoint(x: pauseButton.position.x + pauseButton.size.width + 16, y: pauseButton.position.y)
        exitButton.alpha = 0
        addChild(exitButton)
        
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
                self.audioManager.playSound(.countdown, fromNode: self.backgroundNode)
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
            pauseButton.alpha = 1
            noteLabel.position.y -= noteSpeed
            if audioManager.tracker.amplitude > Double(audioManager.sensitivity!.rawValue) {
                if isPlaying { return }
                isPlaying = true
                for i in octaves {
                    let upperLimit = (note.frequency*i) * (1+(1-tolerance))
                    let lowerLimit = (note.frequency*i) * tolerance
                    if audioManager.tracker.frequency < upperLimit && audioManager.tracker.frequency > lowerLimit {
                        incrementScore(by: 1)
                        destroy(noteLabel, success: true)
                        spawnNote()
                        
                        return
                    }
                }
            } else if audioManager.tracker.amplitude < Double(audioManager.sensitivity!.rawValue) / 2 {
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
    
    private func spawnNote() {
        note = Note.getRandom(withTransposition: Transposition(rawValue: gameManager.transposition))
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
    
    private func destroy(_ node: SKNode, success: Bool) {
        
        if let particles = SKEmitterNode(fileNamed: "explosion.sks") {
            particles.position = node.position
            addChild(particles)
        }
        
        if success {
            let fileSuffix = String((Int(note.frequency.rounded())))
            print(fileSuffix)
            backgroundNode.run(SKAction.playSoundFileNamed("success_"+fileSuffix+".mp3", waitForCompletion: false))
        } else {
            audioManager.playSound(.swoosh, fromNode: backgroundNode)
        }
        
        node.removeFromParent()
        node.removeAllActions()
    }
    
    private func incrementScore(by increment: Int) {
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
    
    private func decreaseLife() {
        numberOfLives -= 1
        destroy(noteLabel, success: false)
        lifeNodes.last?.removeFromParent()
        lifeNodes.removeLast()
        spawnNote()
    }
    
    private func startGame() {
        gameStarted = true
        spawnNote()
    }
    
    private func didTapPause() {
        isPaused.toggle()
        
        createHapticFeedback(style: .light)
        
        if isPaused {
            pauseButton.texture = SKTexture(imageNamed: "Play")
            exitButton.alpha = 1
        } else {
            pauseButton.texture = SKTexture(imageNamed: "Pause")
            exitButton.alpha = 0
        }
    }
    
    private func didTapExit() {
        
        createHapticFeedback(style: .light)
        
        gameStarted = false
        
        gameManager.numberOfGames += 1
        
        if Device.isIpad {
            welcomeScene = WelcomeScene(fileNamed: "WelcomeScenePad.sks")
        } else if Device.hasNotch {
            welcomeScene = WelcomeScene(fileNamed: "WelcomeSceneNotch.sks")
        } else {
            welcomeScene = WelcomeScene(fileNamed: "WelcomeScene.sks")
        }
        
        welcomeScene.scaleMode = .aspectFill
        view?.presentScene(welcomeScene)
    }
    
    private func endGame() {
        gameStarted = false
        
        createHapticFeedback(style: .heavy)
        
        gameManager.numberOfGames += 1
        
        gameManager.requestReview()
        
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
