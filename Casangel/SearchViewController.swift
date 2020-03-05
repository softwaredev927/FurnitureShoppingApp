//
//  SearchViewController.swift
//  CasAngel
//
//  Created by Admin on 02/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class SearchedProductCell: UICollectionViewCell {
    
    public var viewController: SearchViewController? = nil
    public var index: Int = -1
    @IBOutlet var imageView: UIImageView? = nil
    @IBOutlet var nameView: UITextView? = nil
    @IBOutlet var priceView: UITextView? = nil
    
    @IBAction func addToCartClicked() {
        if viewController != nil {
            viewController!.addToCart(self.index)
        }
    }
}

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet var searchBox: UITextField? = nil
    @IBOutlet var collectionView: UICollectionView? = nil
    
    @IBOutlet weak var addProductDlgView: UIView!
    @IBOutlet weak var addProductDlgScrollView: UIScrollView!
    @IBOutlet weak var addProductDlgBackView: UIView!
    @IBOutlet weak var addProductDlgImageView: UIImageView!
    @IBOutlet weak var addProductDlgSmImageTableView: UITableView!
    @IBOutlet weak var addProductDlgNameLabel: UILabel!
    @IBOutlet weak var addProductDlgDescLabel: UILabel!
    
    var searchResult: [ProductDetails]? = nil
    var cartProducts: [Int] = [Int].init()
    
    override func viewDidLoad() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        searchBox?.leftViewMode = .always
        searchBox?.leftView = UIImageView.init(image: UIImage.init(named: "search"))
        searchBox?.borderStyle = .roundedRect
        searchBox?.delegate = self
        GlobalData.clearCarts()
        let button = self.navigationItem.rightBarButtonItem!
        self.hideKeyboardWhenTappedAround()
        DispatchQueue.main.async {
            button.addBadge(number: 0, withOffset: CGPoint.init(x: 6, y: 3), andColor: UIColor.black, andFilled: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loadSearchResults()
        return true
    }
    
    @IBAction func loadSearchResults() {
        let searchKey = self.searchBox?.text!
        self.showLoadingAnim(collectionView: self.collectionView!)
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let params = Parameters(dictionaryLiteral: ("lang", "en-US"), ("search", searchKey!), ("page", "1"), ("per_page", 100), ("order", "desc"), ("orderby", "date"))
            APIClient.getAllProducts(args: params, completionHandler: { (products: [ProductDetails]?, success: Bool) in
                if success {
                    self.searchResult = products
                    DispatchQueue.main.async {
                        self.hideLoadingAnim(collectionView: self.collectionView!)
                        self.collectionView?.reloadData()
                    }
                }
            })
        })
    }
    
    @objc func closeProductDlg() {
        currentProductIdx = -1
        
        DispatchQueue.main.async {
            self.addProductDlgView.isHidden = true
            self.addProductDlgBackView.isHidden = true
        }
    }
    
    var imageTableDs: SmallImageTableViewDS?
    var currentProductIdx = -1
    
    @IBAction func addCurrentProduct() {
        if currentProductIdx >= 0 {
            addToCart(currentProductIdx)
        }
        closeProductDlg()
    }
    
    func showProductDlg(productIndex: Int) {
        DispatchQueue.main.async {
            if let dlg = self.addProductDlgView {
                if let back = self.addProductDlgBackView {
                    back.isHidden = false
                    back.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.closeProductDlg)))
                }
                dlg.isHidden = false
                self.currentProductIdx = productIndex
                self.setImage(imageView: self.addProductDlgImageView, index: productIndex)
                
                self.imageTableDs = SmallImageTableViewDS.init(vc: self, argImages: self.searchResult![productIndex]._images!)
                self.addProductDlgSmImageTableView.dataSource = self.imageTableDs
                self.addProductDlgSmImageTableView.delegate = self.imageTableDs
                
                self.addProductDlgNameLabel.text = self.searchResult?[productIndex]._name
                
                let htmlData = NSString(string: (self.searchResult?[productIndex]._description)!).data(using: String.Encoding.unicode.rawValue)
                
                let attributedString = try! NSAttributedString(data: htmlData!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                self.addProductDlgDescLabel.attributedText = attributedString
                self.addProductDlgDescLabel.sizeToFit()
                
                var contentRect = CGRect.zero
                
                for view in self.addProductDlgScrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                self.addProductDlgScrollView.contentSize = contentRect.size
            }
        }
    }
    
    func setImage(imageView: UIImageView, index: Int, subIndex: Int = 0) {
        var urlStr: String?
        
        let product = searchResult?[index]
        if subIndex < product!._images!.count {
            urlStr = product?._images?[subIndex]._src! ?? ""
        } else {
            imageView.image = nil
            return
        }
        
        imageView.setImageFromUrl(urlStr: urlStr!, completionHandler: { () in
            imageView.contentMode = .scaleAspectFit
        })
    }
    
    func selectSmallImg(_ imgPath: String?) {
        self.addProductDlgImageView.setImageFromUrl(urlStr: imgPath!)
    }
    
    func addToCart(_ index: Int) {
        GlobalData.addToCart(productId: self.searchResult![index]._id!, product: self.searchResult![index])
        self.updateCartButton()
    }
    
    func updateCartButton() {
        let button = self.navigationItem.rightBarButtonItem!
        DispatchQueue.main.async {
            button.updateBadge(number: GlobalData.getCarts().count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchResult != nil {
            return self.searchResult!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! SearchedProductCell
        cell.nameView?.text = searchResult![indexPath.item]._name
        cell.priceView?.text = searchResult![indexPath.item]._price!.withCommas()
        cell.imageView?.setImageFromUrl(urlStr: searchResult![indexPath.item]._images![0]._src!)
        cell.index = indexPath.item
        cell.viewController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showProductDlg(productIndex: indexPath.item)
    }
    
    @IBAction func goBack() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func clickShopCart() {
        self.performSegue(withIdentifier: "GotoCart", sender: self)
    }
}
