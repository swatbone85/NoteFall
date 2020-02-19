import Foundation

class GameManager {
    static let shared = GameManager()
    
    var transposition = UserDefaults.standard.string(forKey: Defaults.transposition) ?? "C" {
        didSet {
            UserDefaults.standard.set(transposition, forKey: Defaults.transposition)
        }
    }
    
    var useAccidentals = UserDefaults.standard.bool(forKey: Defaults.useAccidentals) {
        didSet {
            UserDefaults.standard.set(useAccidentals, forKey: Defaults.useAccidentals)
        }
    }
    
    var highscore = UserDefaults.standard.integer(forKey: Defaults.highscore)
}
