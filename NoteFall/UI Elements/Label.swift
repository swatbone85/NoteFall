import UIKit

class Label: UILabel {
    
    enum FontWeight {
        case regular, bold, thin
    }
    
    convenience init(withText text: String, size: CGFloat, weight: FontWeight? = .regular, alignment: NSTextAlignment? = .justified) {
        self.init()
        
        textColor = .darkGray
        numberOfLines = 0
        
        self.text = text
        
        if let alignment = alignment {
            textAlignment = alignment
        }
        
        switch weight {
        case .bold:
            font = UIFont(name: "AvenirNext-Bold", size: size)
        case .regular:
            font = UIFont(name: "AvenirNext-Regular", size: size)
        case .thin:
            font = UIFont(name: "AvenirNext-Thin", size: size)
        case .none:
            font = UIFont(name: "AvenirNext-Regular", size: size)
        }
    
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}
