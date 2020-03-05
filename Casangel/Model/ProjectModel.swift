//
//  ProjectModel.swift
//  CasAngel
//
//  Created by Admin on 31/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import ObjectMapper

class ProjectModel: Mappable{

    var projectId: Int?
    var projectName: String?
    var projectDt: String?
    var products: [ProductModel]?
    //var backgroundDrawable
    var backgroundFileName: String?
    var thumbFileName: String?
    var rotationDegree: Float?
    var displayWidth: Float?
    var displayHeight: Float?
    
    init() {
        projectId = -1
        rotationDegree = 0
        products = [ProductModel].init()
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.projectId <- map["projectId"]
        self.projectName <- map["projectName"]
        self.projectDt <- map["projectDt"]
        self.products <- map["projectModels"]
        self.backgroundFileName <- map["backgroundFileName"]
        self.thumbFileName <- map["thumbFileName"]
        self.rotationDegree <- map["rotationDegree"]
        self.displayWidth <- map["displayWidth"]
        self.displayHeight <- map["displayHeight"]
    }   
    
}
