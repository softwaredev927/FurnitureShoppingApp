//
//  PostDetails.swift
//  CasAngel
//
//  Created by Admin on 29/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class PostCategory: Mappable {
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _description <- map["description"] 
        _name <- map["name"]
        _link <- map["link"]
        _slug <- map["slug"]
        _image <- map["image"]
        _taxonomy <- map["taxonomy"]
        _parent <- map["parent"]
        __links <- map["_link"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _description: String?
    
    var _link: String?
    
    var _slug: String?
    
    var _image: String?
    
    var _taxonomy: String?
    
    var _parent: Int?
    
    var __links: Links?
}

class PostDetails: Mappable {
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _image <- map["image"]
        _date <- map["date"]
        _date_gmt <- map["date_gmt"]
        _modified <- map["modified"]
        _modified_gmt <- map["modified_gmt"]
        _slug <- map["slug"]
        _status <- map["status"]
        _title <- map["title"]
        _content <- map["content"]
        
        
        _jetpack_featured_media_url <- map["jetpack_featured_media_url"]
    }
    
    
    var _id: Int?
    
    var _image: String?
    
    var _date: String?
    
    var _date_gmt: String?
    
    var _modified: String?
    
    var _modified_gmt: String?
    
    var _slug: String?
    
    var _status: String?
    
    var _type: String?
    
    var _link: String?
    
    var _title: PostTitle?
    
    var _content: PostContent?
    
    var _author: Int?
    
    var _featured_media: Int?
    
    var _comment_status: String?
    
    var _ping_status: String?
    
    var _sticky: Bool?
    
    var _template: String?
    
    var _format: String?
    
    var _categories: [Int]?
    
    var _tags: [String]?
    
    var __embedded: PostEmbedded?
    
    var _jetpack_featured_media_url: String?
}

class PostTitle: Mappable {
    
    var _rendered: String?
    var _protected: Bool?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        _rendered <- map["rendered"]
        _protected <- map["protected"]
    }
}

class PostContent: Mappable {
    
    var _rendered: String?
    var _protected: Bool?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        _rendered <- map["rendered"]
        _protected <- map["protected"]
    }
}

class PostEmbedded: Mappable {
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
}
