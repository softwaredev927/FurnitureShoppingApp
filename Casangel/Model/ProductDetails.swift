//
//  ProductDetails.swift
//  CasAngel
//
//  Created by Admin on 29/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import ObjectMapper

class ProductDetails: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _slug <- map["slug"]
        _permalink <- map["permalink"]
        _date_created <- map["date_created"]
        _date_created_gmt <- map["date_created_gmt"]
        _date_modified <- map["date_modified"]
        _date_modified_gmt <- map["date_modified_gmt"]
        print(self)
        _image <- map["image"]
        _product_image <- map["product_image"]
        _status <- map["status"]
        //_featured <- map["featured"]
        //_type <- map["type"]
        _catalog_visibility <- map["catalog_visibility"]
        _description <- map["description"]
        _short_description <- map["short_description"]
        _sku <- map["sku"]
        _price <- map["price"]
        _regular_price <- map["regular_price"]
        _sale_price <- map["sale_price"]
        _date_on_sale_from <- map["date_on_sale_from"]
        _date_on_sale_from_gmt <- map["date_on_sale_from_gmt"]
        _date_on_sale_to <- map["date_on_sale_to"]
        _date_on_sale_to_gmt <- map["date_on_sale_to_gmt"]
        _price_html <- map["price_html"]
        _on_sale <- map["on_sale"]
        _purchasable <- map["purchasable"]
        _total_sales <- map["total_sales"]
        _virtual <- map["virtual"]
        _downloadable <- map["downloadable"]
        _downloads <- map["downloads"]
        _download_limit <- map["download_limit"]
        _download_expiry <- map["download_expiry"]
        _external_url <- map["external_url"]
        _button_text <- map["button_text"]
        _tax_status <- map["tax_status"]
        _tax_class <- map["tax_class"]
        _manage_stock <- map["manage_stock"]
        _stock_quantity <- map["stock_quantity"]
        _in_stock <- map["in_stock"]
        _backorders <- map["backorders"]
        _backorders_allowed <- map["backorders_allowed"]
        _backordered <- map["backordered"]
        _sold_individually <- map["sold_individually"]
        _weight <- map["weight"]
        _dimensions <- map["dimensions"]
        _shipping_required <- map["shipping_required"]
        _shipping_taxable <- map["shipping_taxable"]
        _shipping_class <- map["shipping_class"]
        _shipping_class_id <- map["shipping_class_id"]
        _reviews_allowed <- map["reviews_allowed"]
        _rating_count <- map["rating_count"]
        _related_ids <- map["related_ids"]
        _upsell_ids <- map["upsell_ids"]
        _cross_sell_ids <- map["cross_sell_ids"]
        _parent_id <- map["parent_id"]
        _purchase_note <- map["purchase_note"]
        _categories <- map["categories"]
        _tags <- map["tags"]
        _images <- map["images"]
        _attributes <- map["attributes"]
        _default_attributes <- map["default_attributes"]
        _variations <- map["variations"]
        _grouped_products <- map["grouped_products"]
        _menu_order <- map["menu_order"]
        __links <- map["links"]
        _isLiked <- map["isLiked"]
        _attributes_price <- map["attributes_price"]
        _final_price <- map["final_price"]
        _total_price <- map["total_price"]
        _customers_basket_quantity <- map["customers_basket_quantity"]
        _category_ids <- map["category_ids"]
        _category_names <- map["category_names"]
        _store <- map["store"]
        _selected_variation <- map["selected_variation"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _in_stock: Bool?
    
    var _slug: String?
    
    var _permalink: String?
    
    var _date_created: String?
    
    var _date_created_gmt: String?
    
    var _date_modified: String?
    
    var _date_modified_gmt: String?
    
    var _type: String?
    
    var _status: String?
    
    var _featured: Bool?
    
    var _catalog_visibility: String?
    
    var _description: String?
    
    var _short_description: String?
    
    var _sku: String?
    
    var _price: String?
    
    var _regular_price: String?
    
    var _sale_price: String?
    
    var _date_on_sale_from: String?
    
    var _date_on_sale_from_gmt: String?
    
    var _date_on_sale_to: String?
    
    var _date_on_sale_to_gmt: String?
    
    var _price_html: String?
    
    var _on_sale: Bool?
    
    var _purchasable: Bool?
    
    var _total_sales: Int?
    
    var _virtual: Bool?
    
    var _downloadable: Bool?
    
    var _downloads: [ProductDownloads]?
    
    var _download_limit: Int?
    
    var _download_expiry: Int?
    
    var _external_url: String?
    
    var _button_text: String?
    
    var _tax_status: String?
    
    var _tax_class: String?
    
    var _manage_stock: Bool?
    
    var _stock_quantity: String?
    
    var _backorders: String?
    
    var _backorders_allowed: Bool?
    
    var _backordered: Bool?
    
    var _sold_individually: Bool?
    
    var _weight: String?
    
    var _dimensions: ProductDimensions?
    
    var _shipping_required: Bool?
    
    var _shipping_taxable: Bool?
    
    var _shipping_class: String?
    
    var _shipping_class_id: Int?
    
    var _reviews_allowed: Bool?
    
    var _average_rating: String?
    
    var _rating_count: Int?
    
    var _related_ids: [Int]?
    
    var _upsell_ids: [Int]?
    
    var _cross_sell_ids: [Int]?
    
    var _parent_id: Int?
    
    var _purchase_note: String?
    
    var _categories: [ProductCategories]?
    
    var _tags: [ProductTags]?

    var _images: [ProductImages]?
    
    var _attributes: [ProductAttributes]?
    
    var _default_attributes: [ProductDefaultAttributes]?
    
    var _variations: [Int]?
    
    var _grouped_products: [Int]?
    
    var _menu_order: Int?
    
    var __links: Links?
    
    var _isLiked: String?
    
    var _attributes_price: String?
    
    var _final_price: String?
    
    var _total_price: String?
    
    var _customers_basket_quantity: Int?
    
    var _category_ids: String?
    
    var _category_names: String?
    
    var _product_image: String?
    
    var _store: Store?
    
    var _image: ProductImages?
    
    var _selected_variation: Int?
}

class ProductDownloads: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _file <- map["file"]
    }
    
    var _id: String?
    
    var _name: String?
    
    var _file: String?
}

class ProductAttributes: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _position <- map["position"]
        _visible <- map["visible"]
        _variation <- map["variation"]
        _option <- map["option"]
        _options <- map["options"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _position: Int?
    
    var _visible: Bool?
    
    var _variation: Bool?
    
    var _option: String?
    
    var _options: [String]?
}

class Store: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _shop_name <- map["shop_name"]
        _url <- map["url"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _shop_name: String?
    
    var _url: String?
}

class ProductDimensions: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _length <- map["length"]
        _width <- map["width"]
        _height <- map["height"]
    }
    
    var _length: String?
    var _width: String?
    var _height: String?
}

class ProductImages: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _date_created <- map["date_created"]
        _date_created_gmt <- map["date_created_gmt"]
        _date_modified <- map["date_modified"]
        _date_modified_gmt <- map["date_modified_gmt"]
        _src <- map["src"]
        _name <- map["name"]
        _alt <- map["alt"]
        _position <- map["position"]
    }
    
    var _id: Int?
    
    var _date_created: String?
    
    var _date_created_gmt: String?
    
    var _date_modified: String?
    
    var _date_modified_gmt: String?
    
    var _src: String?
    
    var _name: String?
    
    var _alt: String?
    
    var _position: Int?
}

class ProductCategories: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _slug <- map["slug"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _slug: String?
}

class ProductDefaultAttributes: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _option <- map["option"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _option: String?
}

class ProductTags: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _slug <- map["slug"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _slug: String?
}

class CouponDetails: Mappable {
    required init?(map: Map) {
        self._valid_items = [Int].init()
    }
    public func mapping(map: Map) {
        _id <- map["id"]
        _code <- map["code"]
        _amount <- map["amount"]
        _discount <- map["discount"]
        _discount_type <- map["discount_type"]
        _date_created <- map["date_created"]
        _date_modified <- map["date_modified"]
        _description <- map["description"]
        _date_expires <- map["date_expires"]
        _usage_count <- map["usage_count"]
        _usage_limit <- map["usage_limit"]
        _usage_limit_per_user <- map["usage_limit_per_user"]
        _limit_usage_to_x_items <- map["limit_usage_to_x_items"]
        _free_shipping <- map["free_shipping"]
        _exclude_sale_items <- map["exclude_sale_items"]
        _individual_use <- map["individual_use"]
        _minimum_amount <- map["minimum_amount"]
        _maximum_amount <- map["maximum_amount"]
        __links <- map["_links"]
        _used_by <- map["used_by"]
        _email_restrictions <- map["email_restrictions"]
        _product_ids <- map["product_ids"]
        _excluded_product_ids <- map["excluded_product_ids"]
        _product_categories <- map["product_categories"]
        _excluded_product_categories <- map["excluded_product_categories"]
        _valid_items_count <- map["valid_items_count"]
        _valid_items <- map["valid_items"]
    }
    
    var _id: Int?
    var _code: String?
    var _amount: String?
    var _discount: String?
    var _discount_type: String?
    var _date_created: String?
    var _date_modified: String?
    var _description: String?
    var _date_expires: String?
    var _usage_count: Int?
    var _usage_limit: Int?
    var _usage_limit_per_user: Int?
    var _limit_usage_to_x_items: Int?
    var _free_shipping: Bool?
    var _exclude_sale_items: Bool?
    var _individual_use: Bool?
    var _minimum_amount: String?
    var _maximum_amount: String?
    var __links: Links?
    var _used_by: [String]?
    var _email_restrictions: [String]?
    var _product_ids: [Int]?
    var _excluded_product_ids: [Int]?
    var _product_categories: [Int]?
    var _excluded_product_categories: [Int]?
    var _valid_items_count: Int?
    var _valid_items: [Int]?
}

class CouponMetaData: Mappable {
    required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        _id <- map["id"]
        _key <- map["key"]
        _values <- map["values"]
    }
    
    var _id: Int?
    var _key: String?
    var _values: String?
}

public class CouponMetaDataValue: Mappable {
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        _id <- map["id"]
        _code <- map["code"]
        _amount <- map["amount"]
        _date_expiry <- map["date_expiry"]
        _discount_type <- map["discount_type"]
        _description <- map["description"]
        _usage_count <- map["usage_count"]
        _individual_use <- map["individual_use"]
        _free_shipping <- map["free_shipping"]
        _exclude_sale_items <- map["exclude_sale_items"]
    }
    
    var _id: Int?
    var _code: String?
    var _amount: String?
    var _date_expiry: String?
    var _discount_type: String?
    var _description: String?
    var _usage_count: Int?
    var _individual_use: Bool?
    var _free_shipping: Bool?
    var _exclude_sale_items: Bool?
}

class OrderDetails: Mappable {
    
    init(){
        
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        token <- map["token"]
        orderKey <- map["order_key"]
        dateCreated <- map["date_created"]
        date_modified <- map["date_modified"]
        discountTotal <- map["discount_total"]
        discountTax <- map["discount_tax"]
        shippingTotal <- map["shipping_total"]
        shippingTax <- map["shipping_tax"]
        cartTax <- map["cart_tax"]
        totalTax <- map["total_tax"]
        total <- map["total"]
        
        customerId <- map["customer_id"]
        status <- map["status"]
        currency <- map["currency"]
        customerNote <- map["customer_note"]
        transactionId <- map["transaction_id"]
        paymentMethod <- map["payment_method"]
        paymentMethodTitle <- map["payment_method_title"]
        setPaid <- map["set_paid"]
        
        sameAddress <- map["sameAddress"]
        billing <- map["billing"]
        shipping <- map["shipping"]
        orderProducts <- map["line_items"]
        orderCoupons <- map["coupon_lines"]
        orderShippingMethods <- map["shipping_lines"]
        orderTaxesList <- map["tax_lines"]
        
    }
    
    var id: Int?
    var token: String?
    var orderKey: String?
    var dateCreated: String?
    var date_modified: String?
    var discountTotal: String?
    var discountTax: String?
    var shippingTotal: String?
    var shippingTax: String?
    var cartTax: String?
    var totalTax: String?
    var total: String?
    var customerId: String?
    var status: String?
    var currency: String?
    var customerNote: String?
    var transactionId: String?
    var paymentMethod: String?
    var paymentMethodTitle: String?
    var setPaid: Bool?
    var sameAddress: Bool?
    var billing: UserBilling?
    var shipping: UserShipping?
    var orderProducts: [OrderProducts]?
    var orderCoupons: [CouponDetails]?
    var orderShippingMethods: [OrderShippingMethod]?
    var orderTaxesList: [OrderTaxes]?
}

class OrderTaxes: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        rateCode <- map["rate_code"]
        rateId <- map["rate_id"]
        label <- map["label"]
        compound <- map["compound"]
        taxTotal <- map["tax_total"]
        shippingTaxTotal <- map["shipping_tax_total"]
    }
    
    var id: Int?
    var rateCode: String?
    var rateId: Int?
    var label: String?
    var compound: Bool?
    var taxTotal: String?
    var shippingTaxTotal: String?
}

class OrderProducts: Mappable {
    
    init() {
        
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        productId <- map["product_id"]
        variationId <- map["variation_id"]
        name <- map["name"]
        quantity <- map["quantity"]
        price <- map["price"]
        subtotal <- map["subtotal"]
        total <- map["total"]
        total_tax <- map["total_tax"]
        taxClass <- map["tax_class"]
        meta_data <- map["meta_data"]
    }
    
    var id: Int?
//    @SerializedName("product_id")
//    @Expose
//    private int productId;
    var productId: Int?
//    @SerializedName("variation_id")
//    @Expose
//    private int variationId;
    var variationId: Int?
//    @SerializedName("name")
//    @Expose
//    private String name;
    var name: String?
//    @SerializedName("quantity")
//    @Expose
//    private int quantity;
    var quantity: Int?
//    @SerializedName("price")
//    @Expose
//    private String price;
    var price: String?
//    @SerializedName("subtotal")
//    @Expose
//    private String subtotal;
    var subtotal: String?
//    @SerializedName("total")
//    @Expose
//    private String total;
    var total: String?
//    @SerializedName("total_tax")
//    @Expose
//    private String totalTax;
    var total_tax: String?
//    @SerializedName("tax_class")
//    @Expose
//    private String taxClass;
    var taxClass: String?
//    @SerializedName("meta_data")
//    @Expose
//    private List<OrderMetaData> metaData = null;
    var meta_data: [OrderMetaData]?
}

public class OrderMetaData: Mappable {
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        key <- map["key"]
        value <- map["value"]
    }
    
    var id: Int?
    var key: String?
    var value: String?
}

public class OrderShippingMethod: Mappable {
    
    init() {
        
    }
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        shippingID <- map["ship_id"]
        methodId <- map["method_id"]
        methodTitle <- map["method_title"]
        total <- map["total"]
    }
    
//
//    @SerializedName("ship_id")
//    @Expose
//    private String shippingID;
    var shippingID: String?
//    @SerializedName("method_id")
//    @Expose
//    private String methodId;
    var methodId: String?
//    @SerializedName("method_title")
//    @Expose
//    private String methodTitle;
    var methodTitle: String?
//    @SerializedName("total")
//    @Expose
//    private String total;
    var total: String?
}

class PlaceOrderParam: Mappable {
    
    init() {
        one_page = "1"
        platform = "Android"
    }
    required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        token <- map["token"]
        billing_info <- map["billing_info"]
        shipping_info <- map["shipping_info"]
        products <- map["products"]
        coupons <- map["coupons"]
        customer_id <- map["customer_id"]
        one_page <- map["one_page"]
        platform <- map["platform"]
    }
    
    
    var token: String?
    var billing_info: UserBilling?
    var shipping_info: UserShipping?
    var products: [OrderProducts]?
    var coupons: [CouponDetails]?
    var customer_id: String?
    var one_page: String?
    var platform: String?
}


class CheckoutParams: Mappable {
    init(){
        
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        billing_info <- map["billing_info"]
        shipping_info <- map["shipping_info"]
        products <- map["products"]
        coupons <- map["coupons"]
        customer_id <- map["customer_id"]
        one_page <- map["one_page"]
        platform <- map["platform"]
    }
    
//    params["token"] = orderDetails.token
//    params["billing_info"] = orderDetails.billing
//    params["shipping_info"] = orderDetails.shipping
//    params["products"] = orderDetails.orderProducts
//    params["coupons"] = orderDetails.orderCoupons
//    params["customer_id"] = orderDetails.customerId
//    params["one_page"] = "1"
//    params["platform"] = "Android"
    var token: String?
    var billing_info: UserBilling?
    var shipping_info: UserShipping?
    var products: OrderProducts?
    var coupons: CouponDetails?
    var customer_id: String?
    var one_page: Int?
    var platform: String?
}
