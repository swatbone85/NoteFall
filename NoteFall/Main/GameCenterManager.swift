import Foundation
import GameKit

class GameCenterManager {
    static let shared = GameCenterManager()
    
    private let LEADERBOARD_ID = "com.leaderboard.notefall"
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    private let scoreToSubmit = GameManager.shared.highscore
    
    func authenticateLocalPlayer(in viewController: UIViewController) {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
             
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                viewController.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                     
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                 
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
    func addToLeaderboard() {
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(scoreToSubmit)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    
    func showLeaderboards(in viewController: UIViewController) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = viewController as? GKGameCenterControllerDelegate
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        viewController.present(gcVC, animated: true, completion: nil)
    }
}
