//
//  OrdersViewController.swift
//  CasAngel
//
//  Created by Admin on 05/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class OrderViewCell: UICollectionViewCell {
    
    var index: Int = -1
    var viewController: OrdersViewController? = nil
    @IBOutlet var orderNo: UITextView? = nil
    @IBOutlet var productNo: UITextView? = nil
    @IBOutlet var productPrice: UITextView? = nil
    @IBOutlet var orderStatus: UITextView? = nil
    @IBOutlet var orderDate: UITextView? = nil
    
    @IBAction func viewDetailClicked() {
        if viewController != nil && index >= 0 {
            viewController?.gotoDetailPage(index: self.index)
        }
    }
}

class OrdersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var ordersCollectionView: UICollectionView? = nil
    var orderDetails: [OrderDetails] = [OrderDetails].init()
    var selectedIndex: Int = -1
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orderDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "order_cell", for: indexPath) as! OrderViewCell
        cell.orderNo?.text = self.orderDetails[indexPath.item].id!.withCommas()
        var productNumber = 0
        var subtotal = 0.0
        for product in self.orderDetails[indexPath.item].orderProducts! {
            productNumber += product.quantity!
            subtotal += Double(product.total!)!
        }
        cell.index = indexPath.item
        cell.viewController = self
        cell.productNo?.text = productNumber.withCommas()
        cell.productPrice?.text = "$ " + subtotal.withCommas()
        let colors: [UIColor] = [.init(red: 196, green: 120, blue: 118), .init(red: 27, green: 91, blue: 126), .init(red: 97, green: 167, blue: 97)]
        cell.orderStatus?.text = self.orderDetails[indexPath.item].status
        var idx = 0
        if cell.orderStatus!.text == "cancelled" {
            idx = 0
        } else if cell.orderStatus!.text == "processing" {
            idx = 1
        } else if cell.orderStatus!.text == "completed" {
            idx = 2
        }
        cell.orderStatus?.textColor = colors[idx]
        cell.orderDate?.text = self.orderDetails[indexPath.item].dateCreated?.replacingOccurrences(of: "T", with: " ")
        return cell
    }
    
    
    override func viewDidLoad() {
        ordersCollectionView?.delegate = self
        ordersCollectionView?.dataSource = self
        self.showLoadingAnim(collectionView: self.ordersCollectionView!)
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let params = Parameters(dictionaryLiteral: ("lang", "en-US"), ("customer", GlobalData.getUserData()?._user?._id! ?? ""), ("page", "1"), ("per_page", 100))
            APIClient.getAllOrders(args: params, completionHandler: { (orders: [OrderDetails]?, success: Bool) in
                if success {
                    self.orderDetails = orders!
                    DispatchQueue.main.async {
                        self.ordersCollectionView?.reloadData()
                        self.hideLoadingAnim(collectionView: self.ordersCollectionView!)
                    }
                }
            })
        })
    }
    
    func gotoDetailPage(index: Int) {
        if index >= 0 && index < self.orderDetails.count {
            selectedIndex = index
            self.performSegue(withIdentifier: "GotoDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let vc = nav.visibleViewController as! OrderDetailViewController
        vc.orderDetails = self.orderDetails[selectedIndex]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 205)
    }
    
    @IBAction func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}
