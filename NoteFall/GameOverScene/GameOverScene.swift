import SpriteKit
class GameOverScene: SKScene {
    
    private let gameManager = GameManager.shared
    
    private var gameOverLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var highscoreLabel: SKLabelNode!
    
    private var tryAgainLabel: SKSpriteNode!
    private var backToMenuLabel: SKSpriteNode!
    private var backgroundNode: SKSpriteNode!
    
    private var welcomeScene: SKScene!
    
    var score = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if tryAgainLabel.contains(touch.location(in: self)) {
            createHapticFeedback(style: .light)
            
            let gameScene = GameScene(fileNamed: "GameScene.sks")
            gameScene?.scaleMode = .resizeFill
            view?.presentScene(gameScene)
        } else if backToMenuLabel.contains(touch.location(in: self)) {
            
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
        
        tryAgainLabel = childNode(withName: "TryAgainButton") as? SKSpriteNode
        
        backToMenuLabel = childNode(withName: "BackToMenuButton") as? SKSpriteNode
        
    }
}
