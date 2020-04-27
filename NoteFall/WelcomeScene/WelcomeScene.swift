import SpriteKit

class WelcomeScene: SKScene {
    
    private var titleLabel: SKLabelNode!
    private var startButton: ButtonNode!
    private var leaderboardsButton: ButtonNode!
    private var settingsButton: ButtonNode!
    private var backgroundNode: SKSpriteNode!
    
    private var infoButton: ButtonNode!
    
    private var settingsScene: SKScene!
    
    private var iapManager = IAPManager.shared
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if startButton.contains(touch.location(in: self)) {
            startGame()
        } else if settingsButton.contains(touch.location(in: self)) {
            showSettings()
        } else if leaderboardsButton.contains(touch.location(in: self)) {
            showLeaderboards()
        } else if infoButton.contains(touch.location(in: self)) {
            showInfoScreen()
        }
    }
    
    override func didMove(to view: SKView) {
        
        backgroundNode = childNode(withName: "Background") as? SKSpriteNode
        backgroundNode.zPosition = Layer.background
        
        titleLabel = childNode(withName: "TitleLabel") as? SKLabelNode
        
        startButton = ButtonNode(withText: Localization.startButtonTitle)
        startButton.position = CGPoint(x: 0, y: 0)
        leaderboardsButton = ButtonNode(withText: Localization.leaderboardsTitle)
        leaderboardsButton.position = CGPoint(x: 0, y: -160)
        settingsButton = ButtonNode(withText: Localization.settingsButtonTitle)
        settingsButton.position = CGPoint(x: 0, y: -320)
        infoButton = ButtonNode(withText: Localization.info)
        infoButton.position = CGPoint(x: 0, y: -480)
        
        if !Device.isIpad {
            startButton.setScale(3)
            leaderboardsButton.setScale(3)
            settingsButton.setScale(3)
            infoButton.setScale(3)
        }
            
        addChild(startButton)
        addChild(leaderboardsButton)
        addChild(settingsButton)
        addChild(infoButton)
    
        animate(titleLabel)
        
        AudioManager.shared.playSound(.navigation, fromNode: backgroundNode)
    }
    
    private func startGame() {
        createHapticFeedback(style: .light)
        
        let gameScene = GameScene()
        gameScene.scaleMode = .resizeFill
        view?.presentScene(gameScene)
    }
    
    private func showLeaderboards() {
        createHapticFeedback(style: .light)
        NotificationCenter.default.post(name: .showLeaderboards, object: nil)
    }
    
    private func showInfoScreen() {
        createHapticFeedback(style: .light)
    }
    
    private func showSettings() {
        
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
