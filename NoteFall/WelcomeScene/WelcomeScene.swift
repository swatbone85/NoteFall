import SpriteKit

class WelcomeScene: SKScene {
    
    fileprivate var titleLabel: SKLabelNode!
    fileprivate var startButton: SKSpriteNode!
    fileprivate var settingsButton: SKSpriteNode!
    
    fileprivate var settingsScene: SKScene!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if startButton.contains(touch.location(in: self)) {
            startGame()
        } else if settingsButton.contains(touch.location(in: self)) {
            showSettings()
        }
    }
    
    override func didMove(to view: SKView) {
        
        titleLabel = childNode(withName: "TitleLabel") as? SKLabelNode
        startButton = childNode(withName: "StartGameButton") as? SKSpriteNode
        settingsButton = childNode(withName: "SettingsButton") as? SKSpriteNode
    
        animate(titleLabel)
        
    }
    
    fileprivate func animate(_ node: SKLabelNode) {
        let scaleUpAction = SKAction.scale(to: 1.1, duration: 1.6)
        let scaleDownAction = SKAction.scale(to: 0.9, duration: 1.6)
        let scaleGroup = SKAction.sequence([scaleUpAction, scaleDownAction])
        let foreverAnimation = SKAction.repeatForever(scaleGroup)
        node.run(foreverAnimation)
    }
    
    fileprivate func startGame() {
        let gameScene = GameScene()
        gameScene.scaleMode = .resizeFill
        view?.presentScene(gameScene)
    }
    
    fileprivate func showSettings() {
        print(screenAspectRatio)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            settingsScene = SettingsScene(fileNamed: "SettingsScenePad.sks")
        } else {
            if screenAspectRatio < 2.17 && screenAspectRatio > 2.16 {
                settingsScene = SettingsScene(fileNamed: "SettingsSceneNotch.sks")
            } else {
                settingsScene = SettingsScene(fileNamed: "SettingsScene.sks")
            }
        }
        
        settingsScene.scaleMode = .aspectFill
        view?.presentScene(settingsScene)
    }
}
