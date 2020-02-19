import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController {
    
    fileprivate var welcomeScene: SKScene!
    
    fileprivate var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-1438547612946932/2924417094"
        bannerView.load(GADRequest())
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["ef91b843e3b249284ffb977f58620a83"]
        
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
        
        addBannerViewToView(bannerView)
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
    
    fileprivate func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let view = view else { return }
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bannerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension GameViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        
        UIView.animate(withDuration: 1) {
            self.bannerView.alpha = 1
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        addBannerViewToView(bannerView)
    }
}
