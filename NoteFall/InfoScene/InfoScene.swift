import SpriteKit

class InfoScene: SKScene {
    
    private var backButton: ButtonNode!
    
    override func didMove(to view: SKView) {
        
        setupBackButton()
        
    }
    
    private func setupBackButton() {
        backButton = ButtonNode(withText: Localization.backToMenuTitle)
        backButton.position = CGPoint(x: 0, y: 100)
        addChild(backButton)
    }
}
