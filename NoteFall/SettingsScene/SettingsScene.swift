import SpriteKit

class SettingsScene: SKScene {
    
    fileprivate var backButton: ButtonNode!
    fileprivate var noAdsButton: ButtonNode!
    fileprivate var transpositionLabel: SKLabelNode!
    fileprivate var accidentalsLabel: SKLabelNode!
    fileprivate var backgroundNode: SKSpriteNode!
    
    fileprivate let gameManager = GameManager.shared
    
    fileprivate var transposition: Transposition!
    
    fileprivate var welcomeScene: SKScene!
    
    fileprivate var transpositionTitle: SKLabelNode!
    fileprivate var accidentalsTitle: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        transposition = Transposition(rawValue: gameManager.transposition)
        
        backgroundNode = childNode(withName: "Background") as? SKSpriteNode
        backgroundNode.zPosition = Layer.background
        
        transpositionTitle = childNode(withName: "TranspositionTitle") as? SKLabelNode
        transpositionTitle.text = Localization.transpositionLabel
        
        accidentalsTitle = childNode(withName: "AccidentalsTitle") as? SKLabelNode
        accidentalsTitle.text = Localization.useAccidentalsLabel
        
        noAdsButton = ButtonNode(withText: Localization.removeAds)
        noAdsButton.position = CGPoint(x: 0, y: -460)
        
        backButton = ButtonNode(withText: Localization.backToMenuTitle)
        backButton.position = CGPoint(x: 0, y: -260)
        
        if !Device.isIpad {
            backButton.setScale(3)
            noAdsButton.setScale(3)
        }
        
        addChild(backButton)
        addChild(noAdsButton)
        
        transpositionLabel = childNode(withName: "TranspositionLabel") as? SKLabelNode
        transpositionLabel.text = gameManager.transposition
        
        accidentalsLabel = childNode(withName: "AccidentalsLabel") as? SKLabelNode
        accidentalsLabel.text = Localization.useAccidentalsLabel
        
        switch gameManager.useAccidentals {
        case true:
            accidentalsLabel.text = Localization.yes
        case false:
            accidentalsLabel.text = Localization.no
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if backButton.contains(touch.location(in: self)) {
            goBackToMenu()
        } else if transpositionLabel.contains(touch.location(in: self)) {
            changeTransposition()
        } else if accidentalsLabel.contains(touch.location(in: self)) {
            toggleAccidentals()
        }
    }
    
    fileprivate func goBackToMenu() {
        saveSettings()
        
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
    
    fileprivate func changeTransposition() {
        
        switch transposition {
        case .C:
            transposition = .Bb
        case .Bb:
            transposition = .Eb
        case .Eb:
            transposition = .F
        case .F:
            transposition = .C
        case .none:
            fatalError("No transposition")
        }
        transpositionLabel.text = transposition.rawValue
        
        createHapticFeedback(style: .light)
    }
    
    fileprivate func toggleAccidentals() {
        gameManager.useAccidentals.toggle()
        
        switch gameManager.useAccidentals {
        case true:
            accidentalsLabel.text = Localization.yes
        case false:
            accidentalsLabel.text = Localization.no
        }
        
        createHapticFeedback(style: .light)
    }
    
    fileprivate func saveSettings() {
        gameManager.transposition = transposition.rawValue
        UserDefaults.standard.synchronize()
    }
}
