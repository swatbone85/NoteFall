import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import GoogleMobileAds

class GameViewController: UIViewController {
    
    fileprivate var welcomeScene: SKScene!
    
    fileprivate var bannerView: GADBannerView!
    
    fileprivate let adManager = AdManager.shared
    
    fileprivate let audioManager = AudioManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadInterstitial), name: .loadInterstitial, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotificationFromIAPManager(_:)), name: .removeAdsFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeBannerAds), name: .removeAdsSucceeded, object: nil)
        
        // Remove on production
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
        
        if !IAPManager.shared.removeAdsPurchased {
            setupBannerView()
            addBannerViewToView(bannerView)
        }
        
    }
    
    private func setupBannerView() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-1438547612946932/2924417094"
        bannerView.load(GADRequest())
        bannerView.rootViewController = self
        bannerView.delegate = self
        
    }
    
    @objc func loadInterstitial() {
        if !IAPManager.shared.removeAdsPurchased {
            //Uncomment on production
            //        interstitialView = GADInterstitial(adUnitID: "ca-app-pub-1438547612946932/6539495953")
                    
                    //Test ad
                    adManager.interstitialView = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
                    adManager.interstitialView.delegate = self
                    let request = GADRequest()
                    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["ef91b843e3b249284ffb977f58620a83"]
                    adManager.interstitialView.load(request)
        }
    }
    
    @objc private func removeBannerAds() {
        bannerView.removeFromSuperview()
    }
    
    @objc private func didReceiveNotificationFromIAPManager(_ notification: Notification) {
        let alertController = UIAlertController(title: Localization.purchaseFailed, message: notification.userInfo!["error"] as? String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Localization.ok, style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        try! AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
//        audioManager.playBackgroundMusic()ra
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

extension GameViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
    }
}
