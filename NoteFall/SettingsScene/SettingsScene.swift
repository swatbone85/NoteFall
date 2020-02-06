import SpriteKit

class SettingsScene: SKScene {
    
    fileprivate var backButton: SKSpriteNode!
    fileprivate var transpositionLabel: SKLabelNode!
    fileprivate var accidentalsLabel: SKLabelNode!
    
    fileprivate let gameManager = GameManager.shared
    
    fileprivate var transposition: Transposition!
    
    override func didMove(to view: SKView) {
        
        transposition = Transposition(rawValue: gameManager.transposition)
        
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
        
        let welcomeScene = WelcomeScene(fileNamed: "WelcomeScene.sks")
        welcomeScene?.scaleMode = .resizeFill
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
    }
    
    fileprivate func toggleAccidentals() {
        gameManager.useAccidentals.toggle()
        
        switch gameManager.useAccidentals {
        case true:
            accidentalsLabel.text = "Yes"
        case false:
            accidentalsLabel.text = "No"
        }
    }
    
    fileprivate func saveSettings() {
        gameManager.transposition = transposition.rawValue
        UserDefaults.standard.synchronize()
    }
}
