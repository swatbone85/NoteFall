import Foundation
import SpriteKit

class ButtonNode: SKShapeNode {
    
    fileprivate let labelNode = SKLabelNode()
    
    init(withText text: String) {
        super.init()
        
        let width = UIScreen.main.bounds.width * 0.4
        let height = width * 0.3
        let cornerRadius: CGFloat = 5
        
        path = UIBezierPath(roundedRect: CGRect(x: -width/2, y: -height/2, width: width, height: height), cornerRadius: cornerRadius).cgPath
        strokeColor = .darkGray
        lineWidth = 1
        
        labelNode.text = text
        labelNode.fontName = "AvenirNext-Regular"
        labelNode.verticalAlignmentMode = .center
        labelNode.fontColor = .darkGray
        labelNode.fontSize = width / 8
        labelNode.numberOfLines = 1
        labelNode.zPosition = 1
        addChild(labelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
