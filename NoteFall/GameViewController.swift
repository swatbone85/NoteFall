//
//  GameViewController.swift
//  NoteFall
//
//  Created by Thomas Swatland on 10/12/2019.
//  Copyright © 2019 Thomas Swatland. All rights reserved.
//

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
            
//            view.showsFPS = true
//            view.showsNodeCount = true
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
