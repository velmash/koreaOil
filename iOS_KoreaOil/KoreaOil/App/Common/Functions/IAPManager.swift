//
//  MnG.swift
//  KoreaOil
//
//  Created by 윤형찬 on 2/21/24.
//

import StoreKit

protocol IAPManagerDelegate {
    func endPay()
}

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()
    var productsRequest: SKProductsRequest?
    var iapProducts = [SKProduct]()
    
    var delegate: IAPManagerDelegate?
    
    func setupIAP() {
        SKPaymentQueue.default().add(self)
        if let productID = Bundle.main.object(forInfoDictionaryKey: "IAPProductID") as? [String] {
            requestProductData(productIDs: productID)
        }
    }
    
    func requestProductData(productIDs: [String]) {
        let productIdentifiers = Set(productIDs)
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            for product in response.products {
                iapProducts.append(product)
            }
        }
    }
    
    func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                self.delegate?.endPay()
            case .failed:
                if let error = transaction.error as? SKError {
                    print("Transaction Failed: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                self.delegate?.endPay()
            default:
                break
            }
        }
    }
    
    func startPurchase() {
        if SKPaymentQueue.canMakePayments() && !iapProducts.isEmpty {
            buyProduct(iapProducts[0])
        }
    }
}
