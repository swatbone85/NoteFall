import Foundation
import SpriteKit
import AudioKit

class AudioManager {
    static let shared = AudioManager()

    private let microphone = AKMicrophone()
    var tracker: AKFrequencyTracker!
    
    var mixer: AKMixer!
    
    fileprivate var backgroundMusicPlayer: AKPlayer!
    
    var isMuted = UserDefaults.standard.bool(forKey: Defaults.isMuted) {
        didSet {
            UserDefaults.standard.set(isMuted, forKey: Defaults.isMuted)
            
            backgroundMusicPlayer.volume = isMuted ? 0 : 1
        }
    }
    
    var sensitivity = MicrophoneSensitivity(rawValue: CGFloat(UserDefaults.standard.float(forKey: Defaults.microphoneSensitivity))) ?? MicrophoneSensitivity(rawValue: MicrophoneSensitivity.high.rawValue) {
        didSet {
            UserDefaults.standard.set(sensitivity!.rawValue, forKey: Defaults.microphoneSensitivity)
        }
    }
    
    func playSound(fromFile file: String, fromNode node: SKNode) {
        if !isMuted {
            node.run(SKAction.playSoundFileNamed(file, waitForCompletion: false))
        }
    }
    
    func playBackgroundMusic() {
        AudioKit.engine.reset()
        try! AudioKit.engine.start()
        backgroundMusicPlayer.volume = isMuted ? 0 : 1
        backgroundMusicPlayer.play()
    }
    
    private init() {
        
        guard let url = Bundle.main.url(forResource: "background", withExtension: "wav") else {
            print("Could not locate background music file.")
            return
        }
        
        backgroundMusicPlayer = AKPlayer(url: url)
        backgroundMusicPlayer.isLooping = true
        try! AKSettings.setSession(category: .playAndRecord, with: .mixWithOthers)
        
        tracker = AKFrequencyTracker(microphone, hopSize: 4096, peakCount: 20)

        let silence = AKBooster(tracker, gain: 0)
        mixer = AKMixer([silence, backgroundMusicPlayer])
        AudioKit.output = mixer
        
        do {
            try AudioKit.start()
            try AKSettings.setSession(category: .playAndRecord, with: .mixWithOthers)
            try AKSettings.setSession(category: .multiRoute)
            try AKSettings.session.setActive(true)
            try AudioKit.engine.start()
        } catch {
            print("AKSettings could not be set.")
        }
    }
}