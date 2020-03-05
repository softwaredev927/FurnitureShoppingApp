//
//  SaveModel.swift
//  CasAngel
//
//  Created by Admin on 31/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import ObjectMapper

class SaveModel: Mappable {
    
    var projects: [ProjectModel]?
    
    init() {
        projects = [ProjectModel].init()
    }
    
    required init?(map: Map) {
        projects = [ProjectModel].init()
    }
    
    func mapping(map: Map) {
        projects <- map["projects"]
    }
}
