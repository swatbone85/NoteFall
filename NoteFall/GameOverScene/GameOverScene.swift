import SpriteKit
class GameOverScene: SKScene {
    
    private var scoreLabel: SKLabelNode!
    private var highscoreLabel: SKLabelNode!
    private let highscore = UserDefaults.standard.integer(forKey: Defaults.highscore)
    
    private var tryAgainLabel: SKSpriteNode!
    private var backToMenuLabel: SKSpriteNode!
    private var backgroundNode: SKSpriteNode!
    
    var score = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if tryAgainLabel.contains(touch.location(in: self)) {
            let gameScene = GameScene(fileNamed: "GameScene.sks")
            gameScene?.scaleMode = .resizeFill
            view?.presentScene(gameScene)
        } else if backToMenuLabel.contains(touch.location(in: self)) {
            let welcomeScene = WelcomeScene(fileNamed: "WelcomeScene.sks")
            welcomeScene?.scaleMode = .resizeFill
            view?.presentScene(welcomeScene)
        }
    }
    
    override func didMove(to view: SKView) {
        
        backgroundNode = childNode(withName: "Background") as? SKSpriteNode
        backgroundNode.zPosition = Layer.background
        
        scoreLabel = childNode(withName: "ScoreLabel") as? SKLabelNode
        scoreLabel.text = String(score)
        
        highscoreLabel = childNode(withName: "HighscoreLabel") as? SKLabelNode
        highscoreLabel.text = String(GameManager.shared.highScore)
        
        tryAgainLabel = childNode(withName: "TryAgainButton") as? SKSpriteNode
        
        backToMenuLabel = childNode(withName: "BackToMenuButton") as? SKSpriteNode
        
    }
}
