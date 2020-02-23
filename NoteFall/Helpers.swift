import Foundation
import UIKit
import SpriteKit

let octaves:[Double] = [1, 2, 4, 8]

struct Note {
    let name: String
    let frequency: Double
    
    static let naturalNotes:[Note] = [Note(name: "A", frequency: 110.00),
                                      Note(name: Localization.b, frequency: 123.47),
                                      Note(name: "C", frequency: 130.81),
                                      Note(name: "D", frequency: 146.83),
                                      Note(name: "E", frequency: 164.81),
                                      Note(name: "F", frequency: 174.61),
                                      Note(name: "G", frequency: 196.00)]
    
    static let flatNotes:[Note] = [Note(name: "Bb", frequency: 116.54),
                                   Note(name: "Db", frequency: 138.59),
                                   Note(name: "Eb", frequency: 155.56),
                                   Note(name: "Gb", frequency: 185.00),
                                   Note(name: "Ab", frequency: 207.65)]
    
    static let sharpNotes:[Note] = [Note(name: "A#", frequency: 116.54),
                                    Note(name: "C#", frequency: 138.59),
                                    Note(name: "D#", frequency: 155.56),
                                    Note(name: "F#", frequency: 185.00),
                                    Note(name: "G#", frequency: 207.65)]
    
}

struct Defaults {
    static let highscore = "highscore"
    static let transposition = "transposition"
    static let useAccidentals = "useAccidentals"
    static let microphoneSensitivity = "microphoneSensitivity"
    static let isMuted = "isMuted"
}

enum Transposition: String {
    case C, Bb, Eb, F
}

struct Device {
    
    static var hasNotch: Bool {
        let screenAspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        return screenAspectRatio < 2.17 && screenAspectRatio > 2.16
    }
    
    static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

struct Layer {
    static let background: CGFloat = -1
}

func createHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.prepare()
    generator.impactOccurred()
}

func animate(_ node: SKLabelNode) {
    let scaleUpAction = SKAction.scale(to: 1.1, duration: 1.6)
    let scaleDownAction = SKAction.scale(to: 0.9, duration: 1.6)
    let scaleGroup = SKAction.sequence([scaleUpAction, scaleDownAction])
    let foreverAnimation = SKAction.repeatForever(scaleGroup)
    node.run(foreverAnimation)
}

extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
