//
//  CategoryDetails.swift
//  CasAngel
//
//  Created by Admin on 29/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//
import ObjectMapper

class CategoryDetails: Mappable {
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _image <- map["image"]
        _name <- map["name"]
        _slug <- map["slug"]
        _parent <- map["parent"]
        _description <- map["description"]
        _display <- map["display"]
        _parent <- map["parent"]
        _menu_order <- map["menu_order"]
        _count <- map["count"]
        _sub_categories <- map["sub_categories"]
        _links <- map["links"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _slug: String?
    
    var _parent: Int?
    
    var _description: String?
    
    var _display: String?
    
    var _image: CategoryImage?
    
    var _menu_order: Int?
    
    var _count: Int?
    
    var _sub_categories: Int?
    
    var _links: Links?
}

class CategoryImage: Mappable {
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _date_created <- map["date_created"]
        _date_created_gmt <- map["date_created_gmt"]
        _date_modified <- map["date_modified"]
        _src <- map["src"]
        _title <- map["title"]
        _alt <- map["alt"]
    }
    
    
    var _id: Int?
    
    var _date_created: String?
    
    var _date_created_gmt: String?
    
    var _date_modified: String?
    
    var _date_modified_gmt: String?
    
    var _src: String?
    
    var _title: String?
    
    var _alt: String?
}

class Links: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _self <- map["self"]
        _collection <- map["collection"]
        _up <- map["up"]
    }
    
    
    //name: self
    var _self: [Links_Self]?
    
    var _collection: [Links_Collection]?
    
    var _up: [Links_Up]?
}

class Links_Self: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _href <- map["href"]
    }
    
    var _href: String?
}

class Links_Collection: Mappable {
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        _href <- map["href"]
    }
    
    var _href: String?
}

class Links_Up: Mappable {
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        _href <- map["href"]
    }
    
    var _href: String?
}
