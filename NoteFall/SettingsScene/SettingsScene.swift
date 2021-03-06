import SpriteKit

class SettingsScene: SKScene {
    
    fileprivate var backButton: ButtonNode!
    
    fileprivate var transpositionTitle: SKLabelNode!
    fileprivate var transpositionLabel: SKLabelNode!
    
    fileprivate var accidentalsTitle: SKLabelNode!
    fileprivate var accidentalsLabel: SKLabelNode!
    
    fileprivate var microphoneTitle: SKLabelNode!
    fileprivate var microphoneLabel: SKLabelNode!
    
    fileprivate var backgroundNode: SKSpriteNode!
    
    fileprivate var muteButtonNode: SKSpriteNode!
    
    fileprivate let gameManager = GameManager.shared
    fileprivate let audioManager = AudioManager.shared
    
    fileprivate var transposition: Transposition!
    
    fileprivate var welcomeScene: SKScene!
    
    override func didMove(to view: SKView) {
        
        transposition = Transposition(rawValue: gameManager.transposition)
        
        guard let image = UIImage(named: audioManager.isMuted ? "MuteIcon" : "SoundIcon")?.tinted(with: .darkGray) else { return }
        let texture = SKTexture(image: image)
        muteButtonNode = childNode(withName: "MuteButton") as? SKSpriteNode
        muteButtonNode.texture = texture
        
        backgroundNode = childNode(withName: "Background") as? SKSpriteNode
        backgroundNode.zPosition = Layer.background
        
        transpositionTitle = childNode(withName: "TranspositionTitle") as? SKLabelNode
        transpositionTitle.text = Localization.transpositionLabel
        transpositionLabel = childNode(withName: "TranspositionLabel") as? SKLabelNode
        transpositionLabel.text = gameManager.transposition
        
        accidentalsTitle = childNode(withName: "AccidentalsTitle") as? SKLabelNode
        accidentalsTitle.text = Localization.useAccidentalsLabel
        accidentalsLabel = childNode(withName: "AccidentalsLabel") as? SKLabelNode
        accidentalsLabel.text = Localization.useAccidentalsLabel
        
        microphoneTitle = childNode(withName: "MicrophoneTitle") as? SKLabelNode
        microphoneTitle.text = Localization.microphoneSensitivityTitle
        microphoneLabel = childNode(withName: "MicrophoneLabel") as? SKLabelNode
        
        switch audioManager.sensitivity {
        case .low:
            microphoneLabel.text = Localization.microphoneSensitivityLow
        case .medium:
            microphoneLabel.text = Localization.microphoneSensitivityMedium
        case .high:
            microphoneLabel.text = Localization.microphoneSensitivityHigh
        case .none:
            break
        }
        
        backButton = ButtonNode(withText: Localization.backToMenuTitle)
        backButton.position = CGPoint(x: 0, y: -260)
        
        if !Device.isIpad {
            backButton.setScale(3)
        }
        
        addChild(backButton)
        
        switch gameManager.useAccidentals {
        case true:
            accidentalsLabel.text = Localization.yes
        case false:
            accidentalsLabel.text = Localization.no
        }
        
        AudioManager.shared.playSound(.navigation, fromNode: backgroundNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if backButton.contains(touch.location(in: self)) {
            audioManager.playSound(.buttonClick, fromNode: backButton)
            goBackToMenu()
        } else if transpositionLabel.contains(touch.location(in: self)) {
            audioManager.playSound(.buttonClick, fromNode: transpositionLabel)
            changeTransposition()
        } else if accidentalsLabel.contains(touch.location(in: self)) {
            audioManager.playSound(.buttonClick, fromNode: accidentalsLabel)
            toggleAccidentals()
        } else if microphoneLabel.contains(touch.location(in: self)) {
            audioManager.playSound(.buttonClick, fromNode: microphoneLabel)
            changeMicrophoneSensitivity()
        } else if muteButtonNode.contains(touch.location(in: self)) {
            toggleMuted()
            audioManager.playSound(.buttonClick, fromNode: muteButtonNode)
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
        welcomeScene.scaleMode = .aspectFill
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
    
    fileprivate func changeMicrophoneSensitivity() {
        switch audioManager.sensitivity {
        case .low:
            audioManager.sensitivity = .medium
            microphoneLabel.text = Localization.microphoneSensitivityMedium
        case .medium:
            audioManager.sensitivity = .high
            microphoneLabel.text = Localization.microphoneSensitivityHigh
        case .high:
            audioManager.sensitivity = .low
            microphoneLabel.text = Localization.microphoneSensitivityLow
        case .none:
            break
        }
        
        createHapticFeedback(style: .light)
    }
    
    fileprivate func toggleMuted() {
        AudioManager.shared.isMuted.toggle()
        guard let image = UIImage(named: audioManager.isMuted ? "MuteIcon" : "SoundIcon")?.tinted(with: .darkGray) else { return }
        let texture = SKTexture(image: image)
        muteButtonNode.texture = texture
        createHapticFeedback(style: .light)
    }
    
    fileprivate func saveSettings() {
        gameManager.transposition = transposition.rawValue
        UserDefaults.standard.synchronize()
    }
}
