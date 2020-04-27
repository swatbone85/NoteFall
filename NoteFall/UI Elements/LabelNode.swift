import SpriteKit

class LabelNode: SKLabelNode {
    
    enum FontWeight {
        case regular, bold, thin
    }
    
    convenience init(withText text: String, weight: FontWeight? = .regular, fontSize: CGFloat, verticalAlignment: SKLabelVerticalAlignmentMode? = .center) {
        self.init()
        
        fontColor = .darkGray
        numberOfLines = 0
        
        horizontalAlignmentMode = .left
        
        if let verticalAlignment = verticalAlignment {
            verticalAlignmentMode = verticalAlignment
        }
        
        self.fontSize = fontSize
        self.text = text
        
        switch weight {
        case .bold:
            fontName = "AvenirNext-Bold"
        case .regular:
            fontName = "AvenirNext-Regular"
        case .thin:
            fontName = "AvenirNext-Thin"
        default:
            break
        }
    }
}
