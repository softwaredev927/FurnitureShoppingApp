//
//  CartModel.swift
//  CasAngel
//
//  Created by Admin on 03/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class CartModel {
    
    var cartId: Int = 0
    
    var productId: Int = 0
    
    var categoryId: String = ""
    
    var productPrice: Double = 0
    
    var productFinalPrice: Double = 0
    
    var productQuantity: Int = 0
    
    var productImageUrl: String = ""
    
    var isValidCouponItem: Bool = true
    
    var isOnScale: Bool = false
    
    var productDetails: ProductDetails? = nil
    
    //var customerBasketQuantity: Int = 0
    
    var totalPrice: Double = 0.0
    
    var productName: String = ""
    
    var selectedVariationID: Int = 0
    
    var taxClass: String = ""
}
