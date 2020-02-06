import SpriteKit

class ScoreLabel: SKLabelNode {

    convenience init(text: String, fontSize size: CGFloat) {
        self.init()
        self.fontSize = size
        self.text = text
    }

    override init() {
        super.init()
        fontName = "HelveticaNeue-Thin"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
