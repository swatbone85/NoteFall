import Foundation

class SoundManager {
    static let shared = SoundManager()
    
    func playSound(fromFile file: String) {
        SKAction.playSoundFileNamed(file, waitForCompletion: false)
    }
}
