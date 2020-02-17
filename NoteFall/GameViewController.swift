import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    fileprivate var welcomeScene: SKScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            if Device.isIpad {
                welcomeScene = WelcomeScene(fileNamed: "WelcomeScenePad.sks")!
            } else if Device.hasNotch {
                welcomeScene = WelcomeScene(fileNamed: "WelcomeSceneNotch.sks")!
            } else {
                welcomeScene = WelcomeScene(fileNamed: "WelcomeScene.sks")!
            }
            welcomeScene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(welcomeScene)
            
            view.ignoresSiblingOrder = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
