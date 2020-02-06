import Foundation
import AudioKit

class MicrophoneManager {
    
    static let shared = MicrophoneManager()
    private let microphone = AKMicrophone()
    
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
