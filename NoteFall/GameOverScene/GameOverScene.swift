import SpriteKit
class GameOverScene: SKScene {
    
    private let gameManager = GameManager.shared
    
    private var gameOverLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var highscoreLabel: SKLabelNode!
    
    private var tryAgainButton: ButtonNode!
    private var backToMenuButton: ButtonNode!
    private var backgroundNode: SKSpriteNode!
    
    private var welcomeScene: SKScene!
    
    var score = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if tryAgainButton.contains(touch.location(in: self)) {
            createHapticFeedback(style: .light)
            
            let gameScene = GameScene(fileNamed: "GameScene.sks")
            gameScene?.scaleMode = .resizeFill
            view?.presentScene(gameScene)
        } else if backToMenuButton.contains(touch.location(in: self)) {
            
            createHapticFeedback(style: .light)
            
            if Device.isIpad {
                welcomeScene = WelcomeScene(fileNamed: "WelcomeScenePad.sks")
            } else if Device.hasNotch {
                welcomeScene = WelcomeScene(fileNamed: "WelcomeSceneNotch.sks")
            } else {
            welcomeScene = WelcomeScene(fileNamed: "WelcomeScene.sks")
            }
            welcomeScene?.scaleMode = .aspectFill
            view?.presentScene(welcomeScene)
        }
    }
    
    override func didMove(to view: SKView) {
        
        gameOverLabel = childNode(withName: "GameOverLabel") as? SKLabelNode
        animate(gameOverLabel)
        
        backgroundNode = childNode(withName: "Background") as? SKSpriteNode
        backgroundNode.zPosition = Layer.background
        
        scoreLabel = childNode(withName: "ScoreLabel") as? SKLabelNode
        scoreLabel.text = String(score)
        
        highscoreLabel = childNode(withName: "HighscoreLabel") as? SKLabelNode
        highscoreLabel.text = String(GameManager.shared.highscore)
        
        tryAgainButton = ButtonNode(withText: "Try again!")
        tryAgainButton.position = CGPoint(x: 0, y: -100)
        
        backToMenuButton = ButtonNode(withText: "Back")
        backToMenuButton.position = CGPoint(x: 0, y: -260)
        
        if !Device.isIpad {
           tryAgainButton.setScale(3)
            backToMenuButton.setScale(3)
        }
        
        addChild(tryAgainButton)
        addChild(backToMenuButton)
        
    }
}
