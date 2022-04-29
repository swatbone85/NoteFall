import Foundation
import UIKit
import SpriteKit

let octaves:[Double] = [1, 2, 4, 8]

struct Note {
    let name: String
    var frequency: Double
    
    static let notes: [Note] = [Note(name: "A", frequency: 110.00),
                                Note(name: "A#", frequency: 116.54),
                                Note(name: "Bb", frequency: 116.54),
                                Note(name: Localization.b, frequency: 123.47),
                                Note(name: "C", frequency: 130.81),
                                Note(name: "C#", frequency: 138.59),
                                Note(name: "Db", frequency: 138.59),
                                Note(name: "D", frequency: 146.83),
                                Note(name: "D#", frequency: 155.56),
                                Note(name: "Eb", frequency: 155.56),
                                Note(name: "E", frequency: 164.81),
                                Note(name: "F", frequency: 174.61),
                                Note(name: "F#", frequency: 185.00),
                                Note(name: "Gb", frequency: 185.00),
                                Note(name: "G", frequency: 196.00),
                                Note(name: "G#", frequency: 207.65),
                                Note(name: "Ab", frequency: 207.65)]
    
    static func getRandom(withTransposition transposition: Transposition? = .C) -> Note {
        
        var transpositionFactor: Double = 1
        var note = GameManager.shared.useAccidentals
            ? notes.randomElement()!
            : notes.filter({$0.name.count == 1}).randomElement()!
        switch transposition {
        case .C:
            transpositionFactor = 1
        case .Bb:
            transpositionFactor = 130.81 / 146.83
        case .Eb:
            transpositionFactor = 116.54 / 196.00
        case .F:
            transpositionFactor = 130.31 / 196.00
        case .none:
            transpositionFactor = 1
        }
        note.frequency *= transpositionFactor
        
        return note
    }
}

struct Defaults {
    static let highscore = "highscore"
    static let transposition = "transposition"
    static let useAccidentals = "useAccidentals"
    static let microphoneSensitivity = "microphoneSensitivity"
    static let noAdsPurchased = "noAdsPurchased"
    static let isMuted = "isMuted"
    static let numberOfGames = "numberOfGames"
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

extension NSNotification.Name {
    static let removeAdsFailed = NSNotification.Name("removeAdsFailed")
    static let loadInterstitial = NSNotification.Name("loadInterstitial")
    static let removeAdsSucceeded = NSNotification.Name("removeAdsSucceeded")
    static let restorePurchasesTapped = NSNotification.Name("restorePurchasesTapped")
    static let restorePurchasesSucceeded = NSNotification.Name("restorePurchasesSucceeded")
    static let showLeaderboards = NSNotification.Name("showLeaderboards")
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
