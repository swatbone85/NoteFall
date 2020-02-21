import Foundation
import SpriteKit

class SoundManager {
    static let shared = SoundManager()
    
    var isMuted = UserDefaults.standard.bool(forKey: Defaults.isMuted) {
        didSet {
            UserDefaults.standard.set(isMuted, forKey: Defaults.isMuted)
        }
    }
    
    func playSound(fromFile file: String, fromNode node: SKNode) {
        if !isMuted {
            node.run(SKAction.playSoundFileNamed(file, waitForCompletion: false))
        }
    }
}
