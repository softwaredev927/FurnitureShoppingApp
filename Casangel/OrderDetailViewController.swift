//
//  OrderDetailViewController.swift
//  CasAngel
//
//  Created by Admin on 05/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    @IBOutlet weak var sectionHeaderlabel: UILabel!
}

class ProductColCell: UICollectionViewCell {
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceView: UILabel!
    @IBOutlet weak var quantityView: UILabel!
    @IBOutlet weak var subtotalView: UILabel!
}

class TwoColCell: UICollectionViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
}

class OneColCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}

class OrderDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var colletionView: UICollectionView? = nil
    var orderDetails: OrderDetails? = nil
    var prductDetails: [ProductDetails] = [ProductDetails].init()
    var productNumber = 0
    var subtotal = 0.0
    var loadingFinished = false
    override func viewDidLoad() {
        self.colletionView?.delegate = self
        self.colletionView?.dataSource = self
        self.showLoadingAnim(collectionView: self.view)
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            APIClient.getSingleOrder(id: (String.init(format:"%d",self.orderDetails!.id!)), completionHandler: { (order: OrderDetails?, success: Bool) in
                if success {
                    self.orderDetails = order
                    for product in self.orderDetails!.orderProducts! {
                        self.productNumber += product.quantity!
                        self.subtotal += Double(product.total!)!
                        APIClient.getSingleProduct(id: (String.init(format:"%d",product.productId!)), completionHandler: { (productDetail: ProductDetails?, success: Bool) in
                            if success {
                                self.prductDetails.append(productDetail!)
                                if self.prductDetails.count == self.orderDetails!.orderProducts!.count {
                                    self.loadingFinished = true
                                    DispatchQueue.main.async {
                                        self.hideLoadingAnim(collectionView: self.view!)
                                        self.colletionView?.reloadData()
                                    }
                                }
                            }
                        })
                    }
                }
            })
        })
    }
    
    @IBAction func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "section", for: indexPath) as! SectionHeader
        let titles = ["Order Details", "Billing Address", "Shipping Address", "Shipping Method", "Products", "Subtotal", "Payment Method"]
        cell.sectionHeaderlabel.text = titles[indexPath.section]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !loadingFinished {
            return 0
        }
        let items = [4, 3, 3, 1, self.prductDetails.count, 5, 1]
        return items[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "two_col", for: indexPath) as! TwoColCell
            let labels = ["No. of Products", "Total Price", "Order Status", "Order Date"]
            
            let values = [productNumber.withCommas(), "$ " + subtotal.withCommas(), self.orderDetails!.status, self.orderDetails!.dateCreated?.replacingOccurrences(of: "T", with: " ")]
            cell.leftLabel.text = labels[indexPath.item]
            cell.rightLabel.text = values[indexPath.item]
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "one_col", for: indexPath) as! OneColCell
            let values = [self.orderDetails?.billing?._address_1, self.orderDetails?.billing?._city, self.orderDetails?.billing?._state]
            cell.label.text = values[indexPath.item]
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "one_col", for: indexPath) as! OneColCell
            let values = [self.orderDetails?.shipping?._address_1, self.orderDetails?.shipping?._city, self.orderDetails?.shipping?._state]
            cell.label.text = values[indexPath.item]
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "one_col", for: indexPath) as! OneColCell
            if self.orderDetails?.orderShippingMethods != nil && (self.orderDetails?.orderShippingMethods!.count)! > 0 {
                cell.label.text = self.orderDetails?.orderShippingMethods![0].methodTitle
            }
            return cell
        } else if indexPath.section == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "two_col", for: indexPath) as! TwoColCell
            let labels = ["Subtotal", "Tax", "Shipping", "Discount", "Total"]
            let values = [ self.subtotal.withCommas(), self.orderDetails?.totalTax!.withCommas(), self.orderDetails!.shippingTotal!.withCommas(), self.orderDetails!.discountTotal!.withCommas(), self.orderDetails!.total!.withCommas()]
            cell.leftLabel.text = labels[indexPath.item]
            cell.rightLabel.text = "$ " + values[indexPath.item]!
            return cell
        } else if indexPath.section == 6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "one_col", for: indexPath) as! OneColCell
            cell.label.text = self.orderDetails?.paymentMethod
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product_col", for: indexPath) as! ProductColCell
            cell.titleView.text = self.orderDetails?.orderProducts![indexPath.item].name
            cell.imageView.setImageFromUrl(urlStr: self.prductDetails[indexPath.item]._images![0]._src!)
            cell.priceView.text = "$ " + self.prductDetails[indexPath.item]._price!.withCommas()
            cell.subtotalView.text = "$ " + (self.orderDetails?.orderProducts![indexPath.item].subtotal)!
            cell.quantityView.text = self.orderDetails?.orderProducts![indexPath.item].quantity?.withCommas()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        if indexPath.section == 4 {
            return CGSize.init(width: width, height: 140)
        } else {
            return CGSize.init(width: width, height: 30)
        }
    }
}
