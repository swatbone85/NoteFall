import Foundation
import GoogleMobileAds

protocol AdManagerDelegate: class {
    func didShowBanner()
    func didShowInterstitial()
}

class AdManager {
    static let shared = AdManager()
    
    fileprivate var adCounter = 0
    fileprivate let adFrequency = 3
    
    fileprivate var bannerView: GADBannerView!
    var interstitialView: GADInterstitial!
    
    private init() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-1438547612946932/2924417094"
    }
    
    func loadAndPresentInterstitial() {
        if adCounter % adFrequency == 0 {
            NotificationCenter.default.post(name: Notification.Name("loadInterstitial"), object: nil)
        }
        adCounter += 1
    }
}
