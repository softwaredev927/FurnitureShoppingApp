//
//  CheckoutViewController.swift
//  CasAngel
//
//  Created by Admin on 05/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class CheckoutViewController: UIViewController, WKNavigationDelegate {
//    private lateinit var orderDetails: OrderDetails
//    private var ORDER_ID: String = ""
//    private var ORDER_RECEIVED = "order-received"
//    private var CHECKOUT_URL = APIClient.BASE_URL + "/android-mobile-checkout"
//    private lateinit var postOrder: PostOrder
    var checkOutUrl = APIClient.BASE_URL + "/android-mobile-checkout"
    var ORDER_RECEIVED = "order-received"
    @IBOutlet var checkoutPage: WKWebView? = nil
    
    override func viewDidLoad() {
        checkoutPage?.navigationDelegate = self
        prepareDataForPlaceOrder()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoadingAnim(collectionView: checkoutPage!)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showLoadingAnim(collectionView: checkoutPage!, alpha: 0.5, type: 1)
        self.addObserver(webView, forKeyPath: "URL", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "URL" {
            if (self.checkoutPage?.url?.absoluteString.contains(ORDER_RECEIVED))! {
                self.checkoutPage?.stopLoading()
                let alertController = UIAlertController(title: "Thank you!", message: "Thank you for shopping with us!", preferredStyle: .alert)

                let confirmAction = UIAlertAction(title: "Okay", style: .default) { (_) in
                    GlobalData.clearCarts()
                    self.performSegue(withIdentifier: "GotoMain", sender: self)
                }
                alertController.addAction(confirmAction)
                //finally presenting the dialog box
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func prepareDataForPlaceOrder() {
        let params: PlaceOrderParam = PlaceOrderParam.init()
        let orderDetails = GlobalData.getOrderDetails()
        params.token = orderDetails?.token
        params.billing_info = orderDetails?.billing
        params.shipping_info = orderDetails?.shipping
        params.products = orderDetails?.orderProducts
        params.coupons = orderDetails?.orderCoupons
        params.customer_id = orderDetails?.customerId
    
        PlaceOrder(jsonData: params.toJSONString()!)
    }
    
    
    //*********** Place the Order on the Server ********//
    
    func PlaceOrder(jsonData: String) {
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            self.showLoadingAnim(collectionView: self.view, alpha: 0.8, type: 1)
            APIClient.placeOrder(args: Parameters.init(dictionaryLiteral: ("insecure","cool"), ("order_link", jsonData)), completionHandler: { (res: String?, success: Bool) in
                if success && res != nil && res! != ""  {
                    self.checkoutPage?.load(URLRequest(url: URL(string: self.checkOutUrl + "?order_id=" + res!)!))
                    self.hideLoadingAnim(collectionView: self.view)
                } else {
                    self.hideLoadingAnim(collectionView: self.view)
                }
            })
        })
    }
}
