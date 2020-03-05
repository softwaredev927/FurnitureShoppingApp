//
//  GlobalData.swift
//  CasAngel
//
//  Created by Admin on 29/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

class GlobalData {
    
    public static var saveModel: SaveModel? = nil
    
    private static var _categories: [CategoryDetails]? = nil
    private static var _post_categories: [PostCategory]? = nil
    private static var _inspire_categories: [PostCategory]? = nil
    private static var _trends: [PostDetails]? = nil
    
    private static var _userData: UserData? = nil
    private static var _loggedin = false
    
    private static var _carts: [Int] = [Int].init()
    private static var _cartModels: [CartModel] = [CartModel].init()
    
    private static var _orderDetails: OrderDetails? = nil
    private static var _homeImages: [String] = [String].init()
    
    public static var userSettings: UserSettings? = nil
    
    public static func addOrderDetails(orderDetails: OrderDetails?) {
        self._orderDetails = orderDetails
    }
    
    public static func getOrderDetails() -> OrderDetails? {
        return self._orderDetails
    }
    
    public static func isLoggedin() -> Bool {
        return self._loggedin
    }
    
    public static func clearCarts() {
        _carts.removeAll()
        _cartModels.removeAll()
    }
    
    public static func addToCart(productId: Int, product: ProductDetails) {
        _carts.append(productId)
        for cart in _cartModels {
            if cart.productId == productId {
                cart.productQuantity = cart.productQuantity + 1
                return
            }
        }
        let cartModel = CartModel()
        cartModel.productId = productId
        cartModel.productQuantity = 1
        let price = Double(product._price ?? "0")!
        cartModel.productPrice = price
        cartModel.productFinalPrice = price
        cartModel.totalPrice = price
        cartModel.productName = product._name ?? ""
        cartModel.selectedVariationID = product._selected_variation ?? 0
        cartModel.taxClass = product._tax_class ?? ""
        cartModel.productImageUrl = (product._images![0]._src)!
        cartModel.categoryId = product._category_ids ?? ""
        cartModel.productDetails = product
        //cartModel.productQuantity = product._customers_basket_quantity ?? 0
        cartModel.isOnScale = product._on_sale ?? false
        _cartModels.append(cartModel)
    }
    
    public static func addToCart(productId: Int, productModel: ProductModel) {
        _carts.append(productId)
        for cart in _cartModels {
            if cart.productId == productId {
                cart.productQuantity = cart.productQuantity + 1
                return
            }
        }
        let cartModel = CartModel()
        cartModel.productId = productId
        cartModel.productQuantity = 1
        cartModel.productPrice = productModel.productPrice ?? 0
        cartModel.productFinalPrice = productModel.productPrice ?? 0
        cartModel.categoryId = productModel.productCategoryId ?? ""
        cartModel.productImageUrl = productModel.productImgSrc ?? ""
        _cartModels.append(cartModel)
    }
    
    public static func getCarts() -> [Int] {
        return _carts
    }
    
    public static func getCartProducts() -> [CartModel] {
        return _cartModels
    }
    
    public static func getCategories() -> [CategoryDetails]?{
        return _categories
    }
    
    public static func removeCartProduct(at: Int) {
        _cartModels.remove(at: at)
    }
    
    public static func setCategories(categories: [CategoryDetails]?) {
        self._categories = categories
        if _categories!.count >= 7 {
            let tmp = _categories![6]
            _categories![6] = _categories![0]
            _categories![0] = tmp
        }
    }
    
    public static func setHomeImages(images: [String]) {
        self._homeImages = images
    }
    
    public static func getHomeImages() -> [String] {
        return self._homeImages 
    }
    
    public static func setPostCategories(categories: [PostCategory]?) {
        self._post_categories = categories
    }
    
    public static func getPostCategories() -> [PostCategory]?{
        return self._post_categories
    }
    
    public static func setInspireCategories(categories: [PostCategory]?) {
        self._inspire_categories = categories
    }
    
    public static func getInspireCategories() -> [PostCategory]?{
        return self._inspire_categories
    }
    
    public static func getTrends() -> [PostDetails]? {
        return self._trends
    }
    
    public static func setTrends(trends: [PostDetails]?) {
        self._trends = trends
    }
    
    public static func loadProjectModel() {
        let def = UserDefaults.standard
        let saveModelStr = def.string(forKey: "SaveModel")
        if saveModelStr == nil {
            saveModel = SaveModel.init()
        } else {
            saveModel = SaveModel.init(JSONString: saveModelStr!)
        }
    }
    
    public static func saveProject(project: ProjectModel) {
        if project.projectId == -1 {
            project.projectId = (saveModel?.projects?.count)!
            saveModel?.projects?.append(project)
        }else {
            saveModel?.projects?[(project.projectId)!] = project
        }
        let def = UserDefaults.standard
        let saveModelStr = saveModel?.toJSONString()
        def.setValue(saveModelStr, forKey: "SaveModel")
    }
    
    public static func removeProject(at: Int) {
        saveModel?.projects?.remove(at: at)
        if at < (saveModel?.projects!.count)! {
            for idx in (at ... (saveModel?.projects!.count)!-1) {
                ((saveModel?.projects)!)[idx].projectId = idx
            }
        }
        let def = UserDefaults.standard
        let saveModelStr = saveModel?.toJSONString()
        def.setValue(saveModelStr, forKey: "SaveModel")
    }
    
    public static func loadProject(projectId: Int) -> ProjectModel? {
        if projectId < (saveModel?.projects?.count)! {
            return saveModel?.projects?[projectId]
        }
        return nil
    }
    
    public static func saveUserData(userData: UserData?) {
        self._userData = userData
        userData?._user?._cookie = userData?._cookie
        if userData?._id != nil {
            userData?._user?._id = userData?._id
        } else if userData?._user?._id == nil {
            userData?._user?._id = 0
        }
        if userData?._user_login != nil {
            userData?._user?._name = userData?._user_login
        }
        if userData?._user?._name != nil {
            userData?._user?._display_name = userData?._user?._name
        }
        let def = UserDefaults.standard
        let userDataStr = userData?.toJSONString()
        def.setValue(userDataStr, forKey: "UserModel")
        self._loggedin = true
    }
    
    public static func loadUserModel() {
        let def = UserDefaults.standard
        let str = def.string(forKey: "UserModel")
        if str == nil {
            return
        }
        let userData = UserData.init(JSONString: str!)
        self._userData = userData
    }
    
    public static func getUserData() -> UserData? {
        return self._userData
    }
}
