//
//  AccountModel.swift
//  CasAngel
//
//  Created by Admin on 02/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

public class Nonce: Mappable {
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self._status <- map["status"]
        self._controller <- map["controller"]
        self._method <- map["method"]
        self._nonce <- map["nonce"]
    }
//    @SerializedName("status")
//    @Expose
//    private String status;
//    @SerializedName("controller")
//    @Expose
//    private String controller;
//    @SerializedName("method")
//    @Expose
//    private String method;
//    @SerializedName("nonce")
//    @Expose
//    private String nonce;
    var _status: String?
    var _controller: String?
    var _method: String?
    var _nonce: String?
}


class RegistrationParam {
    //    @Field("first_name") String firstname,
    //    @Field("last_name") String lastname,
    //    @Field("username") String username,
    //    @Field("email") String email_address,
    //    @Field("password") String password,
    //    @Field("company") String company,
    //    @Field("address_1") String address1,
    //    @Field("address_2") String address2,
    //    @Field("city") String city,
    //    @Field("state") String state,
    //    @Field("phone") String phone,
    //    @Field("nonce") String nonce);
    public var _first_name: String = ""
    public var _last_name: String = ""
    public var _username: String = ""
    public var _email: String = ""
    public var _password: String = ""
    public var _company: String = ""
    public var _state: String = ""
    public var _phone: String = ""
    public var _nonce: String = ""
    
    public func notCompleted() -> Bool {
        if GlobalData.userSettings?.rate_app == "1" {
            if _company == "" || _phone == "" {
                return true
            }
        }
        if _first_name == "" || _last_name == "" || _username == "" || _email == "" || _password == "" {
            return true
        }
        if !_email.isEmail {
            return true
        }
        return false
    }
    
    public func toParameter() -> Parameters {
        return Parameters.init(dictionaryLiteral: ("insecure","cool"), ("first_name", _first_name), ("last_name", _last_name), ("username", _username),
                ("email", _email), ("password", _password), ("company", _company), ("address_1", ""), ("city", ""),
                ("phone", _phone), ("nonce", _nonce))
    }
}

public class UserData: Mappable {
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        _status <- map["status"]
        _error <- map["error"]
        _msg <- map["msg"]
        _message <- map["message"]
        _id <- map["id"]
        _cookie <- map["cookie"]
        _user_login <- map["user_login"]
        _user <- map["user"]
    }
    
//    @SerializedName("status")
//    @Expose
//    private String status;
    var _status: String?
//    @SerializedName("error")
//    @Expose
//    private String error;
    var _error: String?
//    @SerializedName("msg")
//    @Expose
//    private String msg;
    var _msg: String?
//    @SerializedName("message")
//    @Expose
//    private String message;
    var _message: String?
//    @SerializedName("id")
//    @Expose
//    private String id;
    var _id: Int?
//    @SerializedName("cookie")
//    @Expose
//    private String cookie;
    var _cookie: String?
//    @SerializedName("user_login")
//    @Expose
//    private String user_login;
    var _user_login: String?
//    @SerializedName("user")
//    @Expose
//    private UserDetails userDetails;
    var _user: UserDetails?
}

class UserDetails: Mappable {
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        _id <- map["id"]
        _cookie <- map["cookie"]
        _name <- map["name"]
        _first_name <- map["first_name"]
        _last_name <- map["last_name"]
        _nicename <- map["nicename"]
        _nickname <- map["nickname"]
        _display_name <- map["display_name"]
        _email <- map["email"]
        _username <- map["username"]
        _password <- map["password"]
        _role <- map["role"]
        _description <- map["description"]
        _date_created <- map["date_created"]
        _date_created_gmt <- map["date_created_gmt"]
        _date_modified <- map["date_modified"]
        _date_modified_gmt <- map["date_modified_gmt"]
        _billing <- map["billing"]
        _shipping <- map["shipping"]
        _is_paying_customer <- map["is_paying_customer"]
        _orders_count <- map["orders_count"]
        _total_spent <- map["total_spent"]
        _avatar_url <- map["avatar_url"]
        _user_picture <- map["user_picture"]
        _picture <- map["picture"]
        _avatar_url <- map["avatar_url"]
        __links <- map["_links"]
    }
    
    
//    @SerializedName("id")
//    @Expose
//    private String id;
    var _id: Int?
//    @SerializedName("cookie")
//    @Expose
//    private String cookie;
    var _cookie: String?
//    @SerializedName("name")
//    @Expose
//    private String name;
    var _name: String?
//    @SerializedName("first_name")
//    @Expose
//    private String firstName;
    var _first_name: String?
//    @SerializedName("last_name")
//    @Expose
//    private String lastName;
    var _last_name: String?
//    @SerializedName("nicename")
//    @Expose
//    private String nice_name;
    var _nicename: String?
//    @SerializedName("nickname")
//    @Expose
//    private String nick_name;
    var _nickname: String?
//    @SerializedName("display_name")
//    @Expose
//    private String display_name;
    var _display_name: String?
//    @SerializedName("email")
//    @Expose
//    private String email;
    var _email: String?
//    @SerializedName("username")
//    @Expose
//    private String username;
    var _username: String?
//    @SerializedName("password")
//    @Expose
//    private String password;
    var _password: String?
//    @SerializedName("role")
//    @Expose
//    private String role;
    var _role: String?
//    @SerializedName("description")
//    @Expose
//    private String description;
    var _description: String?
//    @SerializedName("date_created")
//    @Expose
//    private String dateCreated;
    var _date_created: String?
//    @SerializedName("date_created_gmt")
//    @Expose
//    private String dateCreatedGmt;
    var _date_created_gmt: String?
//    @SerializedName("date_modified")
//    @Expose
//    private String dateModified;
    var _date_modified: String?
//    @SerializedName("date_modified_gmt")
//    @Expose
//    private String dateModifiedGmt;
    var _date_modified_gmt: String?
//    @SerializedName("billing")
//    @Expose
//    private UserBilling billing;
    var _billing: UserBilling?
//    @SerializedName("shipping")
//    @Expose
//    private UserShipping shipping;
    var _shipping: UserShipping?
//    @SerializedName("is_paying_customer")
//    @Expose
//    private Boolean isPayingCustomer;
    var _is_paying_customer: Bool?
//    @SerializedName("orders_count")
//    @Expose
//    private int ordersCount;
    var _orders_count: Int?
//    @SerializedName("total_spent")
//    @Expose
//    private String totalSpent;
    var _total_spent: String?
//    @SerializedName("avatar_url")
//    @Expose
//    private String avatarUrl;
    var _avatar_url: String?
//    @SerializedName("user_picture")
//    @Expose
//    private String userPicture;
    var _user_picture: String?
//    @SerializedName("picture")
//    @Expose
//    private UserPicture picture;
    var _picture: UserPicture?
//    @SerializedName("_links")
//    @Expose
//    private Links links;
    var __links: Links?
}

class UserBilling: Mappable {
    
    public init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        _first_name <- map["first_name"]
        _last_name <- map["last_name"]
        _company <- map["company"]
        _address_1 <- map["address_1"]
        //_address_2 <- map["address_2"]
        _city <- map["city"]
        _state <- map["state"]
        _postcode <- map["postcode"]
        _country <- map["country"]
        _email <- map["email"]
        _phone <- map["phone"]
        _continent <- map["continent"]
    }
    
    
//    @SerializedName("first_name")
//    @Expose
//    private String firstName;
    var _first_name: String?
//    @SerializedName("last_name")
//    @Expose
//    private String lastName;
    var _last_name: String?
//    @SerializedName("company")
//    @Expose
//    private String company;
    var _company: String?
//    @SerializedName("address_1")
//    @Expose
//    private String address1;
    var _address_1: String?
//    @SerializedName("address_2")
//    @Expose
//    private String address2;
    //var _address_2: String?
//    @SerializedName("city")
//    @Expose
//    private String city;
    var _city: String?
//    @SerializedName("state")
//    @Expose
//    private String state;
    var _state: String?
//    @SerializedName("postcode")
//    @Expose
//    private String postcode;
    var _postcode: String?
//    @SerializedName("country")
//    @Expose
//    private String country;
    var _country: String?
//    @SerializedName("email")
//    @Expose
//    private String email;
    var _email: String?
//    @SerializedName("phone")
//    @Expose
//    private String phone;
    var _phone: String?
//    @SerializedName("continent")
//    @Expose
//    private String continent;
    var _continent: String?
}

class UserShipping: Mappable {
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
        _first_name <- map["first_name"]
        _last_name <- map["last_name"]
        _company <- map["company"]
        _address_1 <- map["address_1"]
        _address_2 <- map["address_2"]
        _city <- map["city"]
        _state <- map["state"]
        _postcode <- map["postcode"]
        _country <- map["country"]
        _continent <- map["continent"]
    }
    
//    @SerializedName("first_name")
//    @Expose
//    private String firstName;
    var _first_name: String?
//    @SerializedName("last_name")
//    @Expose
//    private String lastName;
    var _last_name: String?
//    @SerializedName("company")
//    @Expose
//    private String company;
    var _company: String?
//    @SerializedName("address_1")
//    @Expose
//    private String address1;
    var _address_1: String?
//    @SerializedName("address_2")
//    @Expose
//    private String address2;
    var _address_2: String?
//    @SerializedName("country")
//    @Expose
//    private String country;
    var _country: String?
//    @SerializedName("state")
//    @Expose
//    private String state;
    var _state: String?
//    @SerializedName("city")
//    @Expose
//    private String city;
    var _city: String?
//    @SerializedName("postcode")
//    @Expose
//    private String postcode;
    var _postcode: String?
//    @SerializedName("continent")
//    @Expose
//    private String continent;
    var _continent: String?
}


class UserPicture: Mappable {
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        _data <- map["data"]
    }
    
//    @SerializedName("data")
//    @Expose
//    private UserPictureDetails data;
    var _data: UserPictureDetails?
}

class UserPictureDetails: Mappable {
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        _height <- map["height"]
        _is_silhouette <- map["is_silhouette"]
        _url <- map["url"]
        _width <- map["width"]
    }
    
//    @SerializedName("height")
//    @Expose
//    private int height;
    var _height: Int?
//    @SerializedName("is_silhouette")
//    @Expose
//    private boolean isSilhouette;
    var _is_silhouette: Bool?
//    @SerializedName("url")
//    @Expose
//    private String url;
    var _url: String?
//    @SerializedName("width")
//    @Expose
//    private int width;
    var _width: Int?
}

class UserSettings {
    
    var rate_app: String? = ""
}
