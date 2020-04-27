import Foundation
import GameKit

class GameCenterManager {
    static let shared = GameCenterManager()
    
    private let LEADERBOARD_ID = "com.leaderboard.notefall"
    
    private let localPlayer = GKLocalPlayer.local
    
    func authenticateLocalPlayer(in viewController: UIViewController) {
             
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                viewController.present(ViewController!, animated: true, completion: nil)
            } else {
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
    func addToLeaderboard() {
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        let scoreToSubmit = GameManager.shared.highscore
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
