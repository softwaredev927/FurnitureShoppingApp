//
//  ProductModel.swift
//  CasAngel
//
//  Created by Admin on 31/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import ObjectMapper

class ProductModel: Mappable {
    
    var productId: Int?
    var productPrice: Double?
    var productImgSrc: String?
    var productCategoryId: String?
    var productName: String?
    var productValidationId: Int?
    var productTaxClass: String?
    
    var frameX: Double?
    var frameY: Double?
    var frameWidth: Double?
    var frameHeight: Double?
    var transformA: Double?
    var transformB: Double?
    var transformC: Double?
    var transformD: Double?
    var transformTx: Double?
    var transformTy: Double?
    var borderHidden: Bool?
    var isFlipped: Bool?
    
    init() {
        productId = -1
        borderHidden = false
        isFlipped = false
    }
    
    required init?(map: Map) {
        productId = -1
        borderHidden = false
    }
    
    func mapping(map: Map) {
        productId <- map["productId"]
        productPrice <- map["productPrice"]
        productImgSrc <- map["productImgSrc"]
        productCategoryId <- map["productCategoryId"]
        productValidationId <- map["productValidationId"]
        productName <- map["productName"]
        productTaxClass <- map["productTaxClass"]
        frameX <- map["frameX"]
        frameY <- map["frameY"]
        frameWidth <- map["frameWidth"]
        frameHeight <- map["frameHeight"]
        transformA <- map["transformA"]
        transformB <- map["transformB"]
        transformC <- map["transformC"]
        transformD <- map["transformD"]
        transformTx <- map["transformTx"]
        transformTy <- map["transformTy"]
        borderHidden <- map["borderHidden"]
        isFlipped <- map["isFlipped"]
    }
}
