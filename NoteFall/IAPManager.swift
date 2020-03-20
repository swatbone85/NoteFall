import Foundation
import StoreKit

class IAPManager: NSObject {
    
    static let shared = IAPManager()
    
    let removeAdsID = "com.thomasswatland.NoteFall.RemoveAds"
    
    var products = [SKProduct]()
    
    var removeAdsPurchased = UserDefaults.standard.bool(forKey: Defaults.noAdsPurchased) {
        didSet {
            UserDefaults.standard.set(removeAdsPurchased, forKey: Defaults.noAdsPurchased)
            UserDefaults.standard.synchronize()
        }
    }
    
    var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    private var productsRequest: SKProductsRequest!
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        
        if UserDefaults.standard.bool(forKey: Defaults.noAdsPurchased) {
            removeAdsPurchased = true
        }
    }
    
    func purchaseNoAds() {
        let paymentRequest = SKMutablePayment()
        paymentRequest.productIdentifier = removeAdsID
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    func fetchProducts() {
        let productIdentifiers = Set([removeAdsID])
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        
        productsRequest.delegate = self
        
        productsRequest.start()
    }
    
    func restoreProducts() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased:
                removeAdsPurchased = true
                queue.finishTransaction(transaction)
                NotificationCenter.default.post(name: .removeAdsSucceeded, object: nil)
            case .failed:
                queue.finishTransaction(transaction)
                guard let error = transaction.error else { return }
                NotificationCenter.default.post(name: .removeAdsFailed, object: nil, userInfo: ["error" : error.localizedDescription])
                print(transaction.error!.localizedDescription)
            case .restored:
                queue.finishTransaction(transaction)
                removeAdsPurchased = true
                NotificationCenter.default.post(name: .removeAdsSucceeded, object: nil)
                NotificationCenter.default.post(name: .restorePurchasesSucceeded, object: nil)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            products = response.products
        }
    }
    
    
}
