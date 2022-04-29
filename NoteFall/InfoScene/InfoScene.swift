import SpriteKit

class InfoScene: SKScene {
    
    private let audioManager = AudioManager.shared
    
    private var backButton: ButtonNode!
    
    private var cardView: SKShapeNode!
    
    private var cardWidth: CGFloat!
    
    let infoView = InfoView()
    
    override func didMove(to view: SKView) {
        
        view.addSubview(infoView)
        
        NSLayoutConstraint.activate([
            infoView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
//        setupCardView()
//        setupLabels()
        setupBackButton()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if backButton.contains(touch.location(in: self)) {
            audioManager.playSound(.buttonClick, fromNode: backButton)
            
            goBackToMenu()
        }
    }
    
    private func setupCardView() {
    
        cardWidth = frame.width - 200
        
        cardView = SKShapeNode(rect: CGRect(x: 0, y: 0, width: cardWidth, height: 750), cornerRadius: 24)
        cardView.position = CGPoint(x: -cardWidth/2, y: 260)
        
        cardView.fillColor = .white
        
        addChild(cardView)
    }
    
    private func setupLabels() {
        let labelWidth: CGFloat = cardView.frame.width - 100
        
        let welcomeLabel = LabelNode(withText: Localization.welcomeToNotefall, fontSize: 72)
        welcomeLabel.position = CGPoint(x: 32, y: cardView.frame.maxY / 2)
        
        cardView.addChild(welcomeLabel)
        
        let infoLabel = LabelNode(withText: "The object of the game is to play or sing the note displayed before it disappears off the screen. Score more points by hitting as many correct notes as possible!", fontSize: 48, verticalAlignment: .top)
        infoLabel.preferredMaxLayoutWidth = labelWidth
        infoLabel.position = CGPoint(x: 0, y: -80)
        
        let infoLabel2 = LabelNode(withText: "Adjust the different settings on the Settings page to fit your instrument.", fontSize: 48, verticalAlignment: .top)
        infoLabel2.preferredMaxLayoutWidth = labelWidth
        infoLabel2.position = CGPoint(x: 0, y: -400)
        
        let supportLabel = LabelNode(withText: "Support: notefall@swatland.dev", weight: .bold, fontSize: 32)
        supportLabel.horizontalAlignmentMode = .center
        supportLabel.position = CGPoint(x: 0, y: -240)
        
        welcomeLabel.addChild(infoLabel)
        infoLabel.addChild(infoLabel2)
        cardView.addChild(supportLabel)
    }
    
    private func setupBackButton() {
        backButton = ButtonNode(withText: Localization.backToMenuTitle)
        backButton.position = CGPoint(x: 0, y: -260)
        if !Device.isIpad {
            backButton.setScale(3)
        }
        addChild(backButton)
    }
    
    private func goBackToMenu() {
        infoView.removeFromSuperview()
        
        var welcomeScene: WelcomeScene!
        
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
}
