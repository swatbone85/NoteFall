import SpriteKit

class WelcomeScene: SKScene {
    
    fileprivate var titleLabel: SKLabelNode!
    fileprivate var startButton: ButtonNode!
    fileprivate var settingsButton: ButtonNode!
    fileprivate var backgroundNode: SKSpriteNode!
    
    fileprivate var settingsScene: SKScene!
    
    private var iapManager = IAPManager.shared
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if startButton.contains(touch.location(in: self)) {
            startGame()
        } else if settingsButton.contains(touch.location(in: self)) {
            showSettings()
        }
    }
    
    override func didMove(to view: SKView) {
        
        backgroundNode = childNode(withName: "Background") as? SKSpriteNode
        backgroundNode.zPosition = Layer.background
        
        titleLabel = childNode(withName: "TitleLabel") as? SKLabelNode
        
        startButton = ButtonNode(withText: Localization.startButtonTitle)
        startButton.position = CGPoint(x: 0, y: -100)
        settingsButton = ButtonNode(withText: Localization.settingsButtonTitle)
        settingsButton.position = CGPoint(x: 0, y: -260)
        
        if !Device.isIpad {
            startButton.setScale(3)
            settingsButton.setScale(3)
        }
            
        addChild(startButton)
        addChild(settingsButton)
    
        animate(titleLabel)
    }
    
    fileprivate func startGame() {
        createHapticFeedback(style: .light)
        
        let gameScene = GameScene()
        gameScene.scaleMode = .resizeFill
        view?.presentScene(gameScene)
    }
    
    fileprivate func showSettings() {
        
        if Device.isIpad {
            settingsScene = SettingsScene(fileNamed: "SettingsScenePad.sks")
        } else if Device.hasNotch {
            settingsScene = SettingsScene(fileNamed: "SettingsSceneNotch.sks")
        } else {
            settingsScene = SettingsScene(fileNamed: "SettingsScene.sks")
        }
        
        createHapticFeedback(style: .light)
        
        settingsScene.scaleMode = .aspectFill
        view?.presentScene(settingsScene)
    }
}
