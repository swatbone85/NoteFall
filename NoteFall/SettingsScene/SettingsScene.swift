import SpriteKit

class SettingsScene: SKScene {
    
    fileprivate var backButton: SKSpriteNode!
    fileprivate var transpositionLabel: SKLabelNode!
    fileprivate var accidentalsLabel: SKLabelNode!
    fileprivate var backgroundNode: SKSpriteNode!
    
    fileprivate let gameManager = GameManager.shared
    
    fileprivate var transposition: Transposition!
    
    fileprivate var welcomeScene: SKScene!
    
    override func didMove(to view: SKView) {
        
        transposition = Transposition(rawValue: gameManager.transposition)
        
        backgroundNode = childNode(withName: "Background") as? SKSpriteNode
        backgroundNode.zPosition = Layer.background
        
        backButton = childNode(withName: "BackToMenuButton") as? SKSpriteNode
        
        transpositionLabel = childNode(withName: "TranspositionLabel") as? SKLabelNode
        transpositionLabel.text = gameManager.transposition
        
        accidentalsLabel = childNode(withName: "AccidentalsLabel") as? SKLabelNode
        
        switch gameManager.useAccidentals {
        case true:
            accidentalsLabel.text = "Yes"
        case false:
            accidentalsLabel.text = "No"
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
            //TODO: - Add WelcomeScenePad.sks
//            welcomeScene = WelcomeScene(fileNamed: "WelcomeScenePad.sks")
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
            accidentalsLabel.text = "Yes"
        case false:
            accidentalsLabel.text = "No"
        }
        
        createHapticFeedback(style: .light)
    }
    
    fileprivate func saveSettings() {
        gameManager.transposition = transposition.rawValue
        UserDefaults.standard.synchronize()
    }
}
