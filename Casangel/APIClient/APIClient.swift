//
//  APIClient.swift
//  CasAngel
//
//  Created by Admin on 28/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyXML

enum APIEndpoint: String {
    case GetAllCategories = "wp-json/wc/v2/products/categories"
    case GetAllProducts = "wp-json/wc/v2/products"
    case GetPostCategories = "wp-json/wp/v2/categories"
    case GetAllPosts = "wp-json/wp/v2/posts"
    case ProcessRegistration = "api/AndroidAppUsers/android_register"
    case ProcessLogin = "api/AndroidAppUsers/android_generate_cookie"
    case GetNonce = "api/get_nonce"
    case GetCouponInfo = "wp-json/wc/v2/coupons"
    case ProcessForgotPassword = "api/AndroidAppUsers/android_forgot_password"
    case PlaceOrder = "api/AndroidAppSettings/android_data_link"
    case GetAllOrders = "wp-json/wc/v2/orders"
    case GetSingleOrder = "wp-json/wc/v2/orders/"
}

class APIClient {
    public static let BASE_URL = "https://www.casangel.com.co/"
    
    private static let OAUTH_CONSUMER_KEY = "consumer_key"
    private static let OAUTH_CONSUMER_SECRET = "consumer_secret"
    
    private static let WOOCOMMERCE_CONSUMER_KEY = "ck_c717642db3a4e6bfe0020cc2a8f9c9021f1d6901"
    private static let WOOCOMMERCE_CONSUMER_SECRET = "cs_36e7859a367eace3787efae2845cbbd3ae6d97be"
    
    private static func createPost(url: APIEndpoint, params: Parameters) -> DataRequest? {
        let basicOAuthString = "?" + OAUTH_CONSUMER_KEY + "=" + WOOCOMMERCE_CONSUMER_KEY + "&" + OAUTH_CONSUMER_SECRET + "=" + WOOCOMMERCE_CONSUMER_SECRET
        guard let url = URL(string: BASE_URL + url.rawValue + basicOAuthString) else {
            return nil
        }
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        return Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: headers)
    }
    
    public static func createGet(urlStr: String, params: Parameters) -> DataRequest? {
        let basicOAuthString = "?" + OAUTH_CONSUMER_KEY + "=" + WOOCOMMERCE_CONSUMER_KEY + "&" + OAUTH_CONSUMER_SECRET + "=" + WOOCOMMERCE_CONSUMER_SECRET
        guard let url = URL(string: BASE_URL + urlStr + basicOAuthString) else {
            return nil
        }
        return Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: HTTPHeaders.init())
    }
    
    private static func createGet(url: APIEndpoint, params: Parameters) -> DataRequest? {
        return APIClient.createGet(urlStr: url.rawValue, params: params)
    }
    
    public static func getUserSettings(completionHandler: @escaping (_ userSettings: UserSettings?) -> Void) {
        guard let url = URL(string: "https://www.casangel.com.co/api/AndroidAppSettings/android_get_all_settings/?insecure=cool") else {
            completionHandler(nil)
            return
        }
        let req = Alamofire.request(url, method: .get, parameters: .init(), encoding: URLEncoding.default, headers: HTTPHeaders.init())
                
        req.responseJSON{ resa in switch resa.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary

                //example if there is an id
                var userSettings = UserSettings.init()
                userSettings.rate_app = response["rate_app"] as! String
                completionHandler(userSettings)

            case .failure(let error):
                completionHandler(nil)
            }
        }
    }
    
    //@GET("wp-json/wc/v2/products/categories")
    //Call<List<CategoryDetails>> getAllCategories(@QueryMap Map<String, String> args);
    public static func getAllCategories(args: Parameters, completionHandler: @escaping (_ categories: [CategoryDetails]?, _ success: Bool) -> Void) {
        guard let request = createGet(url: APIEndpoint.GetAllCategories, params: args) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        request.responseArray{ (response: DataResponse<[CategoryDetails]>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            
            guard let value = response.result.value else {
                print("APIClient.getAllCategories failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }
    
    //@GET("wp-json/wc/v2/products")
    //Call<List<ProductDetails>> getAllProducts(@QueryMap Map<String, Object> args );
    public static func getAllProducts(args: Parameters, completionHandler: @escaping (_ categories: [ProductDetails]?, _ success: Bool) -> Void) {
        guard let request = createGet(url: APIEndpoint.GetAllProducts, params: args) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        request.responseArray{ (response: DataResponse<[ProductDetails]>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            
            guard let value = response.result.value else {
                print("APIClient.getAllCategories failed parsing")
                completionHandler(nil, false)
                return
            }
            var res = [ProductDetails]()
            for prod in value {
                if (prod._in_stock!) {
                    res.append(prod)
                }
            }
            completionHandler(res, true)
        }
    }
    
//    @GET("wp-json/wp/v2/categories")
//    Call<List<PostCategory>> getPostCategories(@QueryMap Map<String, String> args );
    public static func getPostCategories(args: Parameters, completionHandler: @escaping (_ categories: [PostCategory]?, _ success: Bool) -> Void) {
        guard let request = createGet(url: APIEndpoint.GetPostCategories, params: args) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        request.responseArray{ (response: DataResponse<[PostCategory]>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            
            guard let value = response.result.value else {
                print("APIClient.getAllCategories failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }
    
    //@GET("wp-json/wp/v2/posts")
    //Call<List<PostDetails>> getAllPosts(@QueryMap Map<String, Object> args );
    public static func getAllPosts(args: Parameters, completionHandler: @escaping (_ categories: [PostDetails]?, _ success: Bool) -> Void) {
        guard let request = createGet(url: APIEndpoint.GetAllPosts, params: args) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        request.responseArray{ (response: DataResponse<[PostDetails]>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            
            guard let value = response.result.value else {
                print("APIClient.getAllPosts failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }
    
//    @FormUrlEncoded
//    @POST("api/AndroidAppUsers/android_register")
//    Call<UserData> processRegistration(@Field("insecure") String insecure,
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
    public static func processRegistration(args: Parameters, completionHandler: @escaping (_ categories: UserData?, _ success: Bool) -> Void) {
        guard let request = createPost(url: APIEndpoint.ProcessRegistration, params: args) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        
        request.responseObject{ (response: DataResponse<UserData>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            guard let value = response.result.value else {
                print("APIClient.ProgcessRegisteration failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }
//    @FormUrlEncoded
//    @POST("api/AndroidAppUsers/android_generate_cookie")
//    Call<UserData> processLogin(                    @Field("insecure") String insecure,
//    @Field("username") String customers_username,
//    @Field("password") String customers_password);
    public static func processLogin(args: Parameters, completionHandler: @escaping (_ categories: UserData?, _ success: Bool) -> Void) {
        guard let request = createPost(url: APIEndpoint.ProcessLogin, params: args) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        
        request.responseObject{ (response: DataResponse<UserData>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            guard let value = response.result.value else {
                print("APIClient.ProcessLogin failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }

//    @GET("api/get_nonce")
//    Call<Nonce> getNonce(@QueryMap Map<String, String> args );
    public static func getNonce(completionHandler: @escaping (_ categories: Nonce?, _ success: Bool) -> Void) {
        let args: Parameters = Parameters.init(dictionaryLiteral: ("controller", "AndroidAppUsers") , ("method", "android_register"))
        guard let request = createGet(url: APIEndpoint.GetNonce, params: args) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        
        request.responseObject{ (response: DataResponse<Nonce>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            guard let value = response.result.value else {
                print("APIClient.ProcessLogin failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }
    
//    @GET("wp-json/wc/v2/coupons")
//    Call<List<CouponDetails>> getCouponInfo(@QueryMap Map<String, String> args );
    public static func getCouponInfo(code: String, completionHandler: @escaping (_ categories: [CouponDetails]?, _ success: Bool) -> Void) {
        let args: Parameters = Parameters.init(dictionaryLiteral: ("code", code))
        guard let request = createGet(url: APIEndpoint.GetCouponInfo, params: args) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        
        request.responseArray{ (response: DataResponse<[CouponDetails]>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            guard let value = response.result.value else {
                print("APIClient.ProcessLogin failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }
//    @FormUrlEncoded
//    @POST("api/AndroidAppUsers/android_forgot_password")
//    Call<UserData> processForgotPassword(           @Field("insecure") String insecure,
//    @Field("email") String customers_email_address);
    public static func processForgotPassword(email: String, completionHandler: @escaping (_ categories: UserData?, _ success: Bool) -> Void) {
        let args: Parameters = Parameters.init(dictionaryLiteral: ("email", email) , ("insecure", "cool"))
        guard let request = createPost(url: APIEndpoint.ProcessForgotPassword, params: args) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        
        request.responseObject{ (response: DataResponse<UserData>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            guard let value = response.result.value else {
                print("APIClient.ProcessLogin failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }
    
//    @FormUrlEncoded
//    @POST("api/AndroidAppSettings/android_data_link")
//    Call<String> placeOrder(                        @Field("insecure") String insecure,
//    @Field("order_link") String order_data);
    public static func placeOrder(args: Parameters, completionHandler: @escaping (_ categories: String?, _ success: Bool) -> Void) {
        guard let request = createPost(url: APIEndpoint.PlaceOrder, params: args) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        
        request.responseString{ (response: DataResponse<String>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            guard let value = response.result.value else {
                print("APIClient.ProcessLogin failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }
//    @GET("wp-json/wc/v2/orders")
//    Call<List<OrderDetails>> getAllOrders(          @QueryMap Map<String, String> args );
    public static func getAllOrders(args: Parameters, completionHandler: @escaping (_ categories: [OrderDetails]?, _ success: Bool) -> Void) {
        guard let request = createGet(url: APIEndpoint.GetAllOrders, params: args) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        
        request.responseArray{ (response: DataResponse<[OrderDetails]>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            guard let value = response.result.value else {
                print("getAllOrders failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }
//
//
//    @GET("wp-json/wc/v2/orders/{id}")
//    Call<OrderDetails> getSingleOrder(@Path("id") String order_id
//    );
    public static func getSingleOrder(id: String, completionHandler: @escaping (_ categories: OrderDetails?, _ success: Bool) -> Void) {
        guard let request = createGet(urlStr: APIEndpoint.GetSingleOrder.rawValue + id, params: Parameters.init()) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        
        request.responseObject{ (response: DataResponse<OrderDetails>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            guard let value = response.result.value else {
                print("getAllOrders failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }
//    @GET("wp-json/wc/v2/products/{id}")
//    Call<ProductDetails> getSingleProduct(          @Path("id") String product_id);
    public static func getSingleProduct(id: String, completionHandler: @escaping (_ productDetail: ProductDetails?, _ success: Bool) -> Void) {
        guard let request = createGet(urlStr: "wp-json/wc/v2/products/" + id, params: Parameters.init()) else {
            print("error")
            completionHandler(nil, false)
            return
        }
        
        request.responseObject{ (response: DataResponse<ProductDetails>) in
            guard response.result.isSuccess else {
                completionHandler(nil, false)
                return
            }
            guard let value = response.result.value else {
                print("getAllOrders failed parsing")
                completionHandler(nil, false)
                return
            }
            completionHandler(value, true)
        }
    }
    //https://www.casangel.com.co/wp-json/wp/v2/posts/7494?consumer_key=ck_c717642db3a4e6bfe0020cc2a8f9c9021f1d6901&consumer_secret=cs_36e7859a367eace3787efae2845cbbd3ae6d97be
    public static func getHomeSlideImages(completionHandler: @escaping (_ images: [String]?)->Void) {
        let urlStr = "https://www.casangel.com.co/wp-json/wp/v2/posts/7494?consumer_key=ck_c717642db3a4e6bfe0020cc2a8f9c9021f1d6901&consumer_secret=cs_36e7859a367eace3787efae2845cbbd3ae6d97be"
        guard let url = URL(string: urlStr) else {
            completionHandler(nil)
            return
        }
        
        let request = Alamofire.request(url, method: .get, parameters: .init(), encoding: URLEncoding.default, headers: HTTPHeaders.init())
        
        request.responseObject{ (response: DataResponse<PostDetails>) in
            guard response.result.isSuccess else {
                completionHandler(nil)
                return
            }
            guard let value = response.result.value else {
                completionHandler(nil)
                return
            }
            
            let resList = value._content!._rendered!.split(separator: "\n")
            var images = [String]()
            for res in resList {
                let xml = XML(string: String(res))
                images.append(xml.children[0].attributes["src"]!)
            }
            completionHandler(images)
        }
    }
}
