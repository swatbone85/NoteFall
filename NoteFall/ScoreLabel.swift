import SpriteKit

class ScoreLabel: SKLabelNode {

    convenience init(text: String, fontSize size: CGFloat) {
        self.init()
        self.text = text
        fontSize = size
        fontColor = .darkGray
    }

    override init() {
        super.init()
        fontName = "HelveticaNeue-Thin"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
