//
//  StoreViewController.swift
//  CasAngel
//
//  Created by Admin on 24/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class CategoryViewCell: UICollectionViewCell {
    
}

class ProductViewCell: UICollectionViewCell {
    public var storeViewController: StoreViewController?
    public var productIndex: Int = -1
    @IBOutlet var productNameView: UITextView? = nil
    @IBOutlet var productPriceView: UITextView? = nil
}

class CategoryAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var storeViewController: StoreViewController? = nil
    var categoryType: Int = 0
    var lastIndexPath: IndexPath? = nil
    
    let color = UIColor.init(rgb: 0xdaa94a)
    var tintColor = UIColor.black
    
    override init() {
        super.init()
    }
    
    func setStoreViewController(vc: StoreViewController) {
        self.storeViewController = vc
    }
    
    func setCategoryType(type: Int) {
        self.categoryType = type
        if type == 2 {
            self.tintColor = UIColor.white
        }
    }
    
    func allLoaded() -> Bool {
        if storeViewController != nil && self.categoryType == 1 {
            return GlobalData.getPostCategories() != nil
        }
        return GlobalData.getCategories() != nil
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if storeViewController != nil && self.categoryType == 1 {
            return GlobalData.getPostCategories()?.count ?? 0
        }
        return GlobalData.getCategories()?.count ?? 0
    }
    
    func setTintColor(color: UIColor) {
        self.tintColor = color
    }
    
    func setImage(imageView: UIImageView, index: Int) -> String{
        if !allLoaded() {
            return "chair"
        }
        let category = GlobalData.getCategories()?[index]
        var urlStr = category?._image?._src!
        if storeViewController != nil && self.categoryType == 1 {
            let post_category = GlobalData.getPostCategories()?[index]
            urlStr = post_category?._description
            if urlStr == "" {
                return "chair"
            }
        }
        
        imageView.setImageFromUrl(urlStr: urlStr!, completionHandler: { () in
            var iColor = self.tintColor
            if self.lastIndexPath?.item == index {
                iColor = self.color
            }
            imageView.contentMode = .scaleAspectFit
            imageView.tintImageColor(color: iColor)
        })
        return category?._name! ?? "chair"
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category_cell", for: indexPath) as! CategoryViewCell
        let imageView = cell.viewWithTag(1) as! UIImageView
        let txtView = cell.viewWithTag(2) as! UITextView
        //imageView.frame.size = CGSize.init(width: 25, height: 50)
        let categoryName = self.setImage(imageView: imageView, index: indexPath.item)
        txtView.text = categoryName
        
        setImage(imageView: imageView, index: indexPath.item)
        if lastIndexPath == nil {
            if indexPath.item == 0 {
                lastIndexPath = indexPath
            }
        }
        if (lastIndexPath != nil && (lastIndexPath?.item == indexPath.item)) {
            //imageView.image = UIImage.init(named: "chair")?.imageWithColor(color1: color)
            imageView.tintImageColor(color: self.color)
            txtView.textColor = color
        }else {
            //imageView.image = UIImage.init(named: "chair")?.imageWithColor(color1: imageView.tintColor)
            imageView.tintImageColor(color: self.tintColor)
            txtView.textColor = self.tintColor
        }
        return cell
    }
    
    func animateCell(cell: UIView) {
        let transition: CATransition = CATransition.init()
        transition.duration = 0.1
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.fade
        transition.repeatCount = 1
        cell.layer.add(transition, forKey: nil)
    }
    
    func selectAt(_ collectionView: UICollectionView, with indexPath: IndexPath) -> CategoryViewCell {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryViewCell
        let imageView = cell.viewWithTag(1) as! UIImageView
        //imageView.image = UIImage.init(named: "chair")?.imageWithColor(color1: color)
        imageView.tintImageColor(color: color)
        let txtView = cell.viewWithTag(2) as! UITextView
        txtView.textColor = color
        return cell
    }
    
    func unselectAt(_ collectionView: UICollectionView, with indexPath: IndexPath) -> CategoryViewCell {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryViewCell
        let imageView = cell.viewWithTag(1) as! UIImageView
        //imageView.image = UIImage.init(named: "chair")?.imageWithColor(color1: imageView.tintColor)
        imageView.tintImageColor(color: tintColor)
        let txtView = cell.viewWithTag(2) as! UITextView
        txtView.textColor = imageView.tintColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if lastIndexPath != nil && indexPath.elementsEqual(lastIndexPath!) {
            return
        }
        let cell = selectAt(collectionView, with: indexPath)
        animateCell(cell: cell)
        //collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if lastIndexPath != nil && collectionView.cellForItem(at: lastIndexPath!) != nil {
            let cell = unselectAt(collectionView, with: lastIndexPath!)
            animateCell(cell: cell)
        }
        lastIndexPath = indexPath
        if storeViewController != nil {
            storeViewController?.loadProducts()
        }
    }
}

class StoreViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var categoriesAdapter = CategoryAdapter()
    var categoriesView: UICollectionView? = nil
    var productsView: UICollectionView? = nil
    @IBOutlet var shadowView: UIView? = nil
    var leftBtn: UIButton? = nil
    var rightBtn: UIButton? = nil
    var products: [ProductDetails]? = nil
    
    @IBOutlet weak var addProductDlgView: UIView!
    @IBOutlet weak var addProductDlgScrollView: UIScrollView!
    @IBOutlet weak var addProductDlgBackView: UIView!
    @IBOutlet weak var addProductDlgImageView: UIImageView!
    @IBOutlet weak var addProductDlgSmImageTableView: UITableView!
    @IBOutlet weak var addProductDlgNameLabel: UILabel!
    @IBOutlet weak var addProductDlgDescLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let catView = self.view.viewWithTag(1) as! UICollectionView
        categoriesView = catView
        catView.dataSource = categoriesAdapter
        catView.delegate = categoriesAdapter
        productsView = self.view.viewWithTag(2) as? UICollectionView
        productsView?.dataSource = self
        productsView?.delegate = self
        productsView?.backgroundColor = UIColor.clear
        categoriesAdapter.lastIndexPath = catView.indexPathForItem(at: CGPoint.init(x: 0, y: 0))
        //shadowView?.addInnerShadow()
        categoriesAdapter.setStoreViewController(vc: self)
        loadProducts()
        GlobalData.clearCarts()
        if categoriesAdapter.categoryType == 0 {
            DispatchQueue.main.async {
                self.initShadow()
                self.navigationItem.rightBarButtonItem?.addBadge(number: 0, withOffset: CGPoint.init(x: 6, y: 3), andColor: UIColor.black, andFilled: false)
            }
        }
        
        if let sc = view.viewWithTag(1333) as? UIScrollView{
            sc.minimumZoomScale = 1.0
            sc.maximumZoomScale = 6.0
        }
    }
    
    func initShadow() {
        let colorTop = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        let colorBottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
        
        let shadowLayer = CAGradientLayer()
        //self.gl.colors = [colorTop, colorBottom]
        shadowLayer.locations = [0.0, 1.0]
        shadowLayer.colors = [colorTop, colorBottom]
        shadowLayer.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: shadowView!.bounds.height)
        shadowView?.layer.addSublayer(shadowLayer)
    }
    
    @IBAction func addProductsToCartClicked() {
        if GlobalData.getCartProducts().count == 0 {
            return
        }
        performSegue(withIdentifier: "GotoCart", sender: self)
    }
    
    var currentProductIdx = -1
    
    @IBAction func addCurrentProduct() {
        if currentProductIdx >= 0 {
            addToCart(productIndex: currentProductIdx)
        }
        closeProductDlg()
    }
    
    @objc func closeProductDlg() {
        currentProductIdx = -1
        
        DispatchQueue.main.async {
            self.addProductDlgView.isHidden = true
            self.addProductDlgBackView.isHidden = true
        }
    }
    
    var imageTableDs: SmallImageTableViewDS?
    
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
                
                self.imageTableDs = SmallImageTableViewDS.init(vc: self, argImages: self.products![productIndex]._images!)
                self.addProductDlgSmImageTableView.dataSource = self.imageTableDs
                self.addProductDlgSmImageTableView.reloadData()
                self.addProductDlgSmImageTableView.delegate = self.imageTableDs
                
                self.addProductDlgNameLabel.text = self.products?[productIndex]._name
                
                let htmlData = NSString(string: (self.products?[productIndex]._description)!).data(using: String.Encoding.unicode.rawValue)
                
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
    
    @objc func chooseProductImage1(_ sender: Any) {
        self.setImage(imageView: self.addProductDlgImageView, index: currentProductIdx, subIndex: 0)
    }
    @objc func chooseProductImage2(_ sender: Any) {
        self.setImage(imageView: self.addProductDlgImageView, index: currentProductIdx, subIndex: 1)
    }
    @objc func chooseProductImage3(_ sender: Any) {
        self.setImage(imageView: self.addProductDlgImageView, index: currentProductIdx, subIndex: 2)
    }
    
    func addToCart(productIndex: Int) {
        if self.products != nil {
            GlobalData.addToCart(productId: (self.products!)[productIndex]._id!, product: (self.products!)[productIndex])
            //self.showToast(message: "Producto añadido")
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.updateBadge(number: GlobalData.getCarts().count)
            }
        }
    }
    
    func showAddProductDlg() {
    }
    
    func loadProducts() {
        self.showLoadingAnim(collectionView: self.productsView!)
        if categoriesAdapter.categoryType == 1 {
            (self as! DesignWayViewController).loadPosts()
            return
        }
        if GlobalData.getCategories() == nil {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            var idx = 0
            if self.categoriesAdapter.lastIndexPath != nil {
                idx = self.categoriesAdapter.lastIndexPath?.item ?? 0
            }
            let categoryId = GlobalData.getCategories()?[idx]._id
            let params = Parameters(dictionaryLiteral: ("lang", "en-US"), ("category", categoryId!), ("page", "1"), ("per_page", 100))
            APIClient.getAllProducts(args: params, completionHandler: { (products: [ProductDetails]?, success: Bool) in
                if success {
                    self.products = products
                    DispatchQueue.main.async {
                        self.productsView?.reloadData()
                        self.hideLoadingAnim(collectionView: self.productsView!)
                    }
                }
            })
        })
    }
    
    func getCategoryType() -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoriesAdapter.categoryType == 1 {
            return (self as! DesignWayViewController).posts?.count ?? 0
        }
        if products == nil {
            return 0
        } else {
            return products?.count ?? 0
        }
    }
    
    func setImage(imageView: UIImageView, index: Int, subIndex: Int = 0) {
        var urlStr: String?
        
        if categoriesAdapter.categoryType == 1 {
            let posts = (self as! DesignWayViewController).posts
            if posts == nil {
                return
            }
            urlStr = posts?[index]._jetpack_featured_media_url
        } else {
            if products == nil {
                return
            }
            let product = products?[index]
            if subIndex < product!._images!.count {
                urlStr = product?._images?[subIndex]._src! ?? ""
            } else {
                imageView.image = nil
                return
            }
        }
        //imageView.setImageFromUrl(urlStr: urlStr!)
        
        imageView.setImageFromUrl(urlStr: urlStr!, completionHandler: { () in
            imageView.contentMode = .scaleAspectFit
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.categoriesAdapter.categoryType == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TemplateViewCell
            let imageView = cell.viewWithTag(1) as! UIImageView
            setImage(imageView: imageView, index: indexPath.item)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductViewCell
        let imageView = cell.viewWithTag(1) as! UIImageView
        cell.storeViewController = self
        cell.productIndex = indexPath.item
        //imageView.image = UIImage.init(named: "shipping")
        setImage(imageView: imageView, index: indexPath.item)
        if categoriesAdapter.categoryType == 0 || categoriesAdapter.categoryType == 2 {
            cell.productNameView?.text = products?[indexPath.item]._name
            cell.productPriceView?.text = products?[indexPath.item]._price?.withCommas()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width - 6
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showProductDlg(productIndex: indexPath.item)
    }
    
    func selectSmallImg(_ imgPath: String?) {
        self.addProductDlgImageView.setImageFromUrl(urlStr: imgPath!)
    }
}

class SmallImageTableViewDS: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var storeVc: UIViewController
    var images: [ProductImages]
    
    init(vc: UIViewController, argImages: [ProductImages]) {
        self.images = argImages
        self.storeVc = vc
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell	 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "smallImageCell") as! SmallImageCell
        cell.imgPhoto.setImageFromUrl(urlStr: images[indexPath.item]._src!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (storeVc is StoreViewController) {
            (storeVc as! StoreViewController).selectSmallImg(images[indexPath.item]._src)
        } else if (storeVc is SearchViewController) {
            (storeVc as! SearchViewController).selectSmallImg(images[indexPath.item]._src)
        }
    }
}

class SmallImageCell: UITableViewCell {
    @IBOutlet weak var imgPhoto: UIImageView!
}

extension StoreViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return addProductDlgImageView
    }
}
