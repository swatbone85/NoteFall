import Foundation
import AudioKit

enum MicrophoneSensitivity: CGFloat {
    case low = 0.45, medium = 0.3, high = 0.25
}

class MicrophoneManager {
    
    static let shared = MicrophoneManager()
    private let microphone = AKMicrophone()
    
    var sensitivity = MicrophoneSensitivity(rawValue: CGFloat(UserDefaults.standard.float(forKey: Defaults.microphoneSensitivity))) ?? MicrophoneSensitivity(rawValue: MicrophoneSensitivity.high.rawValue) {
        didSet {
            UserDefaults.standard.set(sensitivity!.rawValue, forKey: Defaults.microphoneSensitivity)
        }
    }
    
    var tracker: AKFrequencyTracker!
    
    func setupMicrophone() {
        
        tracker = AKFrequencyTracker(microphone, hopSize: 4096, peakCount: 20)
        let silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence
        
        start()
    }
    
    func start() {
        do {
            try AudioKit.start()
        } catch {
            print(error)
        }
    }
    
    func stop() {
        do {
            try AudioKit.stop()
        } catch {
            print(error)
        }
    }
}
