//
//  ShoppingCartViewController.swift
//  CasAngel
//
//  Created by Admin on 03/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class ShoppingCartViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var collectionView: UICollectionView? = nil
    @IBOutlet var totalPriceTextView: UITextView? = nil
    
    var couponItems =  [CouponDetails].init()
    static var alreadyRequestCheckup = false
    
    override func viewDidLoad() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.hideKeyboardWhenTappedAround()
        self.updateCart()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if ShoppingCartViewController.alreadyRequestCheckup {
            self.goCheckout()
        }
    }
    
    var saveOrigin = CGPoint(x: 0, y: 0)
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let n = GlobalData.getCartProducts().count + couponItems.count
            if saveOrigin.y == 0 && n >= 2 {
                DispatchQueue.main.async {
                    self.saveOrigin = self.collectionView!.frame.origin
                }
                self.collectionView!.frame.origin = CGPoint(x: saveOrigin.x, y: saveOrigin.y - keyboardSize.height)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if saveOrigin.y != 0 {
            DispatchQueue.main.async {
                self.collectionView!.frame.origin = self.saveOrigin
            }
            saveOrigin = CGPoint(x: 0, y: 0)
        }
    }
    func updateTotalPrice() {
        self.totalPriceTextView?.text = "Total: $" + cartTotalPrice.withCommas()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalData.getCartProducts().count + couponItems.count + 1
    }
    
    var cartTotalPrice = 0.0
    var cartSubTotal = 0.0
    var cartDiscount = 0.0
    var disableOtherCoupons = false
    //*********** Update Cart Products and Cart Coupons ********//
    
    func updateCart() {
        var subtotal = 0.0
        var totalDiscount = 0.0
    
        // Calculate Cart's total Price
        for product in GlobalData.getCartProducts() {
            subtotal += product.productFinalPrice
        }
    
        for product in GlobalData.getCartProducts() {
            product.totalPrice = product.productFinalPrice
        }
        
        if (couponItems.count > 0) {
            var cidx = 0
            for coupon in couponItems {
    
                var validItemsCount = 0
                var cartHasValidItemsForCoupon = false
                for product in GlobalData.getCartProducts() {
                    if (coupon._valid_items?.contains(product.productId))! {
                        cartHasValidItemsForCoupon = true
                        validItemsCount += product.productQuantity
                    }
            
                    coupon._valid_items_count = validItemsCount
                }
        
                // Check if Coupon is Valid
                if (!validateCoupon(coupon: coupon) || !cartHasValidItemsForCoupon) {
                    self.couponItems.remove(at: cidx)
                    cidx = cidx - 1
        
                } else {
                    var couponDiscount = 0.0
            
                    if coupon._discount_type == "fixed_product" {
                        for cart in GlobalData.getCartProducts() {
                            if coupon._valid_items!.contains(cart.cartId) {
                                couponDiscount += Double(coupon._amount ?? "0")! * Double(cart.productQuantity)
                            }
                        }
                    }else if coupon._discount_type == "fixed_cart" {
                        couponDiscount = Double(coupon._amount ?? "0")!
                    } else if (coupon._discount_type == "percent") {
                        couponDiscount = subtotal * Double(coupon._amount ?? "0")! / 100
                    }
            
                    let productDiscount = couponDiscount / Double(coupon._valid_items_count!)
            
                    for cart in GlobalData.getCartProducts() {
                        if coupon._valid_items!.contains(cart.productId) {
                            let totalPrice = Double(cart.totalPrice) - productDiscount * Double(cart.productQuantity)
                            cart.totalPrice = totalPrice
                        }
                    }
                    coupon._discount = String.init(format: "%f", couponDiscount)
                }
                cidx = cidx + 1
            }
        }
        
        for coupon in couponItems {
            totalDiscount += Double(coupon._discount ?? "0")!
        }
    
    
        let total = subtotal - totalDiscount
    
        cartTotalPrice = total
        cartSubTotal = subtotal
        cartDiscount = totalDiscount
    
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.updateTotalPrice()
        }
    }
    //*********** Validate given Coupon ********//
    
    public func validateCoupon(coupon: CouponDetails) -> Bool {
    
        var user_used_this_coupon_counter = 0
    
        var user_usage_limit_exceeds = false               // false
        var coupon_usage_limit_exceeds = false             // false
        var items_limit_exceeds_to_usage = false           // false
        var user_email_valid_for_coupon = false            // true
        var any_valid_item_in_cart = false                 // true
        var any_valid_category_item_in_cart = false        // true
        var all_sale_items_in_cart = true                  // false
        var all_excluded_items_in_cart = true              // false
        var all_excluded_category_items_in_cart = true     // false
    
    
        for i in coupon._used_by! {
            if GlobalData.getUserData()?._user?._id != 0 {
                if i.contains(String.init(format:"%d",GlobalData.getUserData()!._user!._id!)) {
                    user_used_this_coupon_counter += 1
                }
            }
        }
    
    
        if (coupon._usage_limit_per_user ?? 0 != 0 && user_used_this_coupon_counter >= coupon._usage_limit_per_user!) {
            user_usage_limit_exceeds = true
        }
    
    
        if (coupon._usage_limit ?? 0 != 0 && coupon._usage_count ?? 0 >= coupon._usage_limit!) {
            coupon_usage_limit_exceeds = true
        }
    
    
        if (coupon._limit_usage_to_x_items ?? 0 != 0 && GlobalData.getCartProducts().count >= coupon._limit_usage_to_x_items ?? 0) {
            items_limit_exceeds_to_usage = true
        }
        
        if (coupon._email_restrictions!.count > 0 && GlobalData.getUserData()?._user?._email ?? "" != "") {
            for _email in coupon._email_restrictions! {
                if _email == GlobalData.getUserData()?._user?._email {
                    user_email_valid_for_coupon = true
                    break
                }
            }
        } else {
            user_email_valid_for_coupon = true
        }
        
        for cart in GlobalData.getCartProducts() {
    
            var isValidProduct = true
            var isExcludedOnSale = false
            var isExcludedProduct = true
            var anyValidCategory = false
            var anyExcludedCategory = true
    
    
            let productID = cart.cartId
            var categoryIDs = [String].init()
            if cart.categoryId != "" {
                categoryIDs = cart.categoryId.replacingOccurrences(of: "\\s", with: "").components(separatedBy: ",")
            }
    
            var categoryIDsList = [Int].init()
            if categoryIDs.count > 0 {
                for catId in categoryIDs {
                    categoryIDsList.append(Int(catId)!)
                }
            }
    
            if (coupon._exclude_sale_items!) {
                if (!cart.isOnScale) {
                    all_sale_items_in_cart = false
                } else {
                    isExcludedOnSale = true
                }
            } else {
                all_sale_items_in_cart = false
            }
    
    
            if (coupon._product_ids!.count > 0) {
                if ((coupon._product_ids?.contains(productID))!) {
                    any_valid_item_in_cart = true
                } else {
                    isValidProduct = false
                }
            } else {
                any_valid_item_in_cart = true
            }
    
    
            if (coupon._product_categories!.count > 0 && categoryIDs.isEmpty) {
                for catId in categoryIDs {
                    if coupon._product_categories!.contains(Int(catId)!) {
                        anyValidCategory = true
                        any_valid_category_item_in_cart = true
                    }
                }
            } else {
                anyValidCategory = true
                any_valid_category_item_in_cart = true
            }
    
    
            if (coupon._excluded_product_ids!.count > 0) {
                if (!(coupon._excluded_product_ids?.contains(productID))!) {
                    isExcludedProduct = false
                    all_excluded_items_in_cart = false
                }
            } else {
                isExcludedProduct = false
                all_excluded_items_in_cart = false
            }
    
    
            if (coupon._excluded_product_categories!.count > 0 && categoryIDs.isEmpty) {
                for cat in categoryIDs {
                    if !coupon._excluded_product_categories!.contains(Int(cat)!) {
                        anyExcludedCategory = false
                        all_excluded_category_items_in_cart = false
                    }
                }
            } else {
                anyExcludedCategory = false
                all_excluded_category_items_in_cart = false
            }
    
    
    
            if (!isExcludedOnSale && !isExcludedProduct && !anyExcludedCategory && isValidProduct && anyValidCategory) {
                cart.isValidCouponItem = true
            } else {
                cart.isValidCouponItem = false
                
            }
        }
        
        if (coupon._date_expires == nil || !coupon._date_expires!.checkIsDatePassed()) {
            if (!coupon_usage_limit_exceeds && !user_usage_limit_exceeds && user_email_valid_for_coupon &&
                Double(coupon._minimum_amount!)! <= cartSubTotal && (Double(coupon._minimum_amount!)! == 0.0 || cartSubTotal <= Double(coupon._minimum_amount!)!) && !items_limit_exceeds_to_usage  && !all_sale_items_in_cart && !all_excluded_category_items_in_cart && !all_excluded_items_in_cart && any_valid_category_item_in_cart && any_valid_item_in_cart) {
    
                return true
            }
        }
        return false
    }

    
    //*********** Apply given Coupon to checkout ********//
    
    func applyCoupon(coupon: CouponDetails) {
    
        var validItemsCount = 0
        var couponDiscount = 0.0
        
        if (coupon._discount_type == "fixed_product") {
            for product in GlobalData.getCartProducts() {
                if (product.isValidCouponItem) {
                    validItemsCount += product.productQuantity//cartItemsList[i].cartProduct.customersBasketQuantity
                    couponDiscount += Double(coupon._amount!)! * Double(product.productQuantity)
                }
            }
        } else if (coupon._discount_type == "fixed_cart") {
        
            couponDiscount = Double(coupon._amount!)!
            
            for product in GlobalData.getCartProducts() {
                if (product.isValidCouponItem) {
                    validItemsCount += product.productQuantity
                }
            }
        
        } else if (coupon._discount_type == "percent") {
        
            couponDiscount = cartSubTotal * Double(coupon._amount!)! / 100
            
            for cart in GlobalData.getCartProducts() {
                if (cart.isValidCouponItem) {
                    validItemsCount += cart.productQuantity
                }
            }
            if validItemsCount == 0 {
                return
            }
        }
    
    
        if (couponDiscount + cartDiscount >= cartSubTotal) {
            //showSnackBarForCoupon(getString(R.string.coupon_cannot_be_applied))
        
        } else {
        
            let productDiscount = couponDiscount / Double(validItemsCount)
        
            for product in GlobalData.getCartProducts() {
                if (product.isValidCouponItem) {
                    if (0 > Double(product.totalPrice) - productDiscount) {
                        product.isValidCouponItem = false
                        validItemsCount -= product.productQuantity
                    }
                }
            }
            
            if coupon._valid_items == nil {
                coupon._valid_items = [Int].init()
            }
            for product in GlobalData.getCartProducts() {
                if (product.isValidCouponItem) {
                    coupon._valid_items!.append(product.productId)
                }
            }
            
            
            var coupon_applied_already = false
            
            if self.couponItems.count != 0 {
                for cp in self.couponItems {
                    if coupon._code == cp._code {
                        coupon_applied_already = true
                    }
                }
            }
        
        
            if (!disableOtherCoupons) {
                if (!coupon_applied_already) {
                    if (validItemsCount > 0) {
                
                        if (coupon._individual_use!) {
                            couponItems.removeAll()
                            disableOtherCoupons = true
                        }
                    
                        coupon._valid_items_count = validItemsCount
                        coupon._discount = String.init(format: "%lf", couponDiscount)
                        couponItems.append(coupon)
                        updateCart()
                    
                    } else {
                        //showSnackBarForCoupon(getString(R.string.coupon_cannot_be_applied))
                    }
                } else {
                    //showSnackBarForCoupon(getString(R.string.coupon_applied))
                }
            } else {
                //howSnackBarForCoupon(getString(R.string.coupon_cannot_used_with_existing))
            }
        }
    
    }
    
    //*********** Set Order Details and Proceed to Checkout ********//
    
    func proceedCheckout() {
    
        // Get the customerID and customerToken and defaultAddressID from SharedPreferences
        let customerID = GlobalData.getUserData()?._user?._id!
        let customerToken = GlobalData.getUserData()?._user?._cookie!
    
    
        let orderDetails = OrderDetails()
        var orderProductsList = [OrderProducts].init()
    
        for cart in GlobalData.getCartProducts() {
            let orderProduct = OrderProducts()
            
            orderProduct.id = cart.productId
            orderProduct.productId = cart.productId
            orderProduct.variationId = cart.selectedVariationID
            orderProduct.quantity = cart.productQuantity
            orderProduct.name = cart.productName
            orderProduct.price = cart.productPrice.toString()
            orderProduct.subtotal = cart.productFinalPrice.toString()
            orderProduct.total = cart.totalPrice.toString()
            orderProduct.taxClass = cart.taxClass
        
            orderProductsList.append(orderProduct)
        }
    
    
        orderDetails.setPaid = false
        orderDetails.discountTotal = cartDiscount.toString()
        orderDetails.total = cartTotalPrice.toString()
        orderDetails.dateCreated = Date.init().toString()
    
        orderDetails.orderCoupons = self.couponItems
        orderDetails.orderProducts = orderProductsList
    
        orderDetails.token = customerToken
        orderDetails.customerId = String.init(format:"%d", customerID!)
    
    
        var shippingMethodsList = [OrderShippingMethod].init()
        let shippingMethods = OrderShippingMethod()
        shippingMethods.methodId = ""
        shippingMethods.methodTitle = ""
        shippingMethods.total = ""
        shippingMethodsList.append(shippingMethods)
    
    
        orderDetails.sameAddress = false
        orderDetails.billing = GlobalData.getUserData()?._user?._billing
        orderDetails.shipping = GlobalData.getUserData()?._user?._shipping
        orderDetails.orderShippingMethods = shippingMethodsList
    
    
        // Save the OrderDetails
        GlobalData.addOrderDetails(orderDetails: orderDetails)
    
        //startActivity(CheckoutActivity::class.java)
        APIClient.getUserSettings{ (users: UserSettings?) in
            if (users != nil && users!.rate_app == "1") {
                self.performSegue(withIdentifier: "GotoCheckout", sender: self)
            } else {
                let alertVc = UIAlertController.init(
                    title: "Gracias por ordenar nuestro producto.",
                    message: "Su pedido será revisado por el administrador y después de eso le enviaremos los artículos que ordenó y usted lo pagará.\nGracias.",
                    preferredStyle: .alert)
                
                let agreeAction = UIAlertAction.init(title: "De acuerdo", style: .default) { (action: UIAlertAction) in
                    alertVc.dismiss(animated: true)
                    let confirmVc = UIAlertController.init(
                        title: "Su pedido enviado",
                        message: "Su pedido ha sido enviado y se lo enviaremos.\nGracias.",
                        preferredStyle: .alert)
                    
                    confirmVc.addAction(UIAlertAction.init(title: "OKAY!", style: .default) { (action: UIAlertAction) in
                        confirmVc.dismiss(animated: true) {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                    self.present(confirmVc, animated: true, completion: nil)
                }
                
                let disagreeAction = UIAlertAction.init(title: "Discrepar", style: .cancel){ (action: UIAlertAction) in
                    alertVc.dismiss(animated: true, completion: nil)
                }
                
                alertVc.addAction(disagreeAction)
                alertVc.addAction(agreeAction)
                
                self.present(alertVc, animated: true, completion: nil)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let totalCount = GlobalData.getCartProducts().count + couponItems.count
        let productCount = GlobalData.getCartProducts().count
        if indexPath.item == totalCount { //action cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "action_cell", for: indexPath) as! CartActionCell
            if self.couponItems.count == 0 {
                cell.discountViewParent.isHidden = true
                cell.subTotalViewParent.isHidden = true
            } else {
                cell.discountViewParent.isHidden = false
                cell.subTotalViewParent.isHidden = false
                cell.discountView.text = "$ " + self.cartDiscount.withCommas()
                cell.subTotalView.text = "$ " + self.cartSubTotal.withCommas()
            }
            cell.shoppingCartViewController = self
            
            cell.addMoreProductBtn.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.addMoreProductBtnClicked)))
            print("cell  --- 111")
            return cell
        } else if indexPath.item < productCount { //product cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cart_cell2", for: indexPath) as! ShoppingCartCell
            let quantity = GlobalData.getCartProducts()[indexPath.item].productQuantity
            cell.quantityTextView?.text = quantity.withCommas()
            cell.priceTextView?.text = "$" + Double(GlobalData.getCartProducts()[indexPath.item].productPrice).withCommas()
            cell.totalPriceTextView?.text = "$" + Double(GlobalData.getCartProducts()[indexPath.item].productPrice * Double(quantity)).withCommas()
            cell.index = indexPath.item
            cell.productImageView?.setImageFromUrlFit(urlStr: GlobalData.getCartProducts()[indexPath.item].productImageUrl)
            cell.viewController = self
            print("cell  --- 2222")
            return cell
        } else { //coupon cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coupon_cell", for: indexPath) as! CouponCell
            let couponDetails = self.couponItems[indexPath.item - productCount]
            cell.couponCode.text = couponDetails._code
            let discountStr = couponDetails._discount?.withCommas()
            cell.couponDiscount.text = "$ " + discountStr!
            cell.couponAmount.text = "$ " + (couponDetails._amount?.withCommas())!
            cell.couponType.text = couponDetails._discount_type
            cell.couponIndex = indexPath.item - productCount
            cell.shoppingCartViewController = self
            print("cell  --- 333")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.width, height: 160)
    }
    
    @objc func addMoreProductBtnClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goCheckout() {
        if GlobalData.getUserData() == nil {
            ShoppingCartViewController.alreadyRequestCheckup = true
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "GotoLogin", sender: self)
            }
        } else {
            ShoppingCartViewController.alreadyRequestCheckup = false
            
            if GlobalData.isLoggedin() &&
                GlobalData.getUserData()?._user != nil &&
                GlobalData.getUserData()?._user!._id != nil
                && GlobalData.getUserData()?._user?._cookie != nil {
                
                self.proceedCheckout()
            } else {
                self.showLoadingAnim(collectionView: self.view, alpha: 0.8, type: 1, showString: "Login ...")
                DispatchQueue.global(qos: .userInitiated).async(execute: {
                    let oldUserData = GlobalData.getUserData()
                    APIClient.processLogin(args: Parameters.init(dictionaryLiteral: ("insecure","cool"), ("username", GlobalData.getUserData()!._user!._username!), ("password", GlobalData.getUserData()!._user!._password!)), completionHandler: { (userData: UserData?, success: Bool) in
                        if success && userData?._status == "ok"  {
                            userData?._user?._password = oldUserData?._user?._password
                            GlobalData.saveUserData(userData: userData)
                            self.hideLoadingAnim(collectionView: self.view)
                            self.proceedCheckout()
                        } else {
                            self.hideLoadingAnim(collectionView: self.view)
                            //self.showToast(message: "can't login")
                        }
                    })
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GotoLogin" {
            let navController = segue.destination as! UINavigationController
            let accVc = navController.visibleViewController as! AccountContainerViewController
            accVc.pageType = 1
        }
    }
}

class CartActionCell: UICollectionViewCell {
    
    var shoppingCartViewController: ShoppingCartViewController?
    @IBOutlet weak var addMoreProductBtn: UITextView!
    @IBOutlet weak var couponCodeField: UITextField!
    @IBOutlet weak var couponApplyBtn: UIButton!
    @IBOutlet weak var subTotalView: UITextView!
    @IBOutlet weak var discountView: UITextView!
    @IBOutlet weak var subTotalViewParent: UIView!
    @IBOutlet weak var discountViewParent: UIView!
    
    @IBAction func applyCouponClicked() {
        let couponCode = self.couponCodeField.text!
        if couponCode == "" {
            return
        }
        shoppingCartViewController?.showLoadingAnim(collectionView: shoppingCartViewController!.view, alpha: 0.8, type: 1)
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            APIClient.getCouponInfo(code: couponCode, completionHandler: { (couponDetails: [CouponDetails]?, success: Bool) in
                if success {
                    DispatchQueue.main.async {
                        self.shoppingCartViewController?.hideLoadingAnim(collectionView: self.shoppingCartViewController!.view!)
                    }
                    for coupon in couponDetails! {
                        if ((self.shoppingCartViewController?.validateCoupon(coupon: coupon))!) {
                            self.shoppingCartViewController?.applyCoupon(coupon: coupon)
                            self.couponCodeField.text = ""
                        }
                    }
                }
            })
        })
    }
}

class CouponCell: UICollectionViewCell {
    
    var couponIndex: Int = -1
    var shoppingCartViewController: ShoppingCartViewController?
    @IBOutlet weak var couponCode: UITextView!
    @IBOutlet weak var couponAmount: UITextView!
    @IBOutlet weak var couponDiscount: UITextView!
    @IBOutlet weak var couponType: UITextView!
    
    @IBAction func removeCoupon() {
        if shoppingCartViewController != nil && couponIndex >= 0 {
            shoppingCartViewController?.couponItems.remove(at: self.couponIndex)
            DispatchQueue.main.async {
                self.shoppingCartViewController?.updateCart()
            }
        }
    }
    
}

class ShoppingCartCell: UICollectionViewCell {
    
    var index: Int = 0
    var viewController: ShoppingCartViewController? = nil
    
    @IBOutlet var quantityTextView: UILabel? = nil
    @IBOutlet var priceTextView: UILabel? = nil
    @IBOutlet var totalPriceTextView: UILabel? = nil
    @IBOutlet var productImageView: UIImageView? = nil
    
    @IBAction func increaseQuantity() {
        GlobalData.getCartProducts()[index].productQuantity += 1
        updatePrice()
    }
    
    @IBAction func decreaseQuantity() {
        if GlobalData.getCartProducts()[index].productQuantity <= 1 {
            return
        }
        GlobalData.getCartProducts()[index].productQuantity -= 1
        updatePrice()
    }
    
    func updatePrice() {
        let quantity = GlobalData.getCartProducts()[index].productQuantity
        DispatchQueue.main.async {
            self.quantityTextView?.text = String.init(format: "%d", quantity)
            GlobalData.getCartProducts()[self.index].productFinalPrice = Double(GlobalData.getCartProducts()[self.index].productPrice * Double(quantity))
            self.totalPriceTextView?.text = "$" + Double(GlobalData.getCartProducts()[self.index].productPrice * Double(quantity)).withCommas()
            self.viewController?.updateCart()
        }
    }
    
    @IBAction func removeProduct() {
        GlobalData.removeCartProduct(at: self.index)
        DispatchQueue.main.async {
            self.viewController?.updateCart()
        }
    }
}
