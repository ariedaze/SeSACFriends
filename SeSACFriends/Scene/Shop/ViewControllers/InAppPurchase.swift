//
//  InAppPurchase.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/21.
//

import UIKit
import StoreKit

class InAppViewController: UIViewController {
    // 1. 인앱 상품 ID 정의
    var productIdentifiers: Set<String> = ["cheetahfitcoffee"]
    
    // 3-1. 인앱 상품 배열 (1은 문자열, 이건 다양한 정보 포함)
    var productArray = Array<SKProduct>()
    var product: SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestProductData()
        let button = UIBarButtonItem(title: "구매", style: .plain, target: self, action: #selector(buttonClicked))
        self.navigationItem.rightBarButtonItem = button
    }
    
    // 2. productIdentifiers에 정의된 상품ID에 대한 정보 가져오기 및 사용자의 디바이스가 인앱결제가 가능한지 여부 확인
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start() // 인앱 상품 조회
        } else {
            print("In App Purchase Not Enabled")
        }
    }
    
    // 영수증 검증
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        //https://sandbox.itunes.apple.com/verifyReceipt
        //https://buy.itunes.apple.com/verifyReceipt
        // 구매 영수증 정보
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(receiptString)
        
        // 거래 내역(transaction)을 큐에서 제거
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    // 4. 구매 버튼 클릭
    @objc func buttonClicked() {
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
    }
}


extension InAppViewController: SKProductsRequestDelegate {
    // 3. 인앱 상품 정보 조회
    // response: 응답에 대한 정보
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        
        if !products.isEmpty {
            // 상품을 하나씩 조회
            for i in products {
                productArray.append(i)
                product = i
                print("product")
                print(i.localizedTitle, i.price, i.priceLocale, i.localizedDescription)
                dump(i)
            }
        } else {
            print("No Product Found")
        }
    }
}

// SKPaymentTransactionObserver: 구매 취소, 승인 등에 대한 프로토콜. 업데이트 된 거래 내역 받아보기
extension InAppViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing: // 구매 승인 이후에 영수증 검증
                print("Transaction Approved, \(transaction.payment.productIdentifier)")
                receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
                // 영수증 검증
            case .failed: // 실패 토스트, transaction
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction) // 거래내역에서 제거

            @unknown default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print(#function)
    }
}
