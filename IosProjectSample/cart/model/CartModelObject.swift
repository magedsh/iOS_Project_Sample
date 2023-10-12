//
//  CartModelObject.swift
//  LaowaiQuestions
//
//  Created by Macbook on 04/01/2023.
//  Copyright © 2023 Maged Shaheen. All rights reserved.
//

import Foundation
import RealmSwift

class CartDataObject : Object , Codable{
    @objc dynamic var currentAuthUser = UserData.getUserId()

    @objc dynamic var product_id: Int = 0
    @objc dynamic var product_name: String = ""
    @objc dynamic var product_image: String = ""
    @objc dynamic var product_code: String = ""
    @objc dynamic var product_price: Int = 0
    @objc dynamic var product_ctns: Double = 0.0

    @objc dynamic var product_weight: Double = 0
    @objc dynamic var product_cbm: Double = 0
    @objc dynamic var product_max_qty: Int = 0

    @objc dynamic var product_min_qty: Int = 0
    @objc dynamic var product_current_qty: Int = 0
    @objc dynamic var product_Inner_qty: Int = 0 // for ctns

    @objc dynamic var store_id: Int = 0
    @objc dynamic var store_owner_id: Int = 0
    @objc dynamic var createdAt:Date? = Date()
    @objc dynamic var modifiedAt:Date?
    @objc dynamic var qtyExpanded = false
    
    @objc dynamic var product_ctns_all: Double = 0.0
    @objc dynamic var product_weight_all: Double = 0
    @objc dynamic var product_cbm_all: Double = 0

    var cartAttributs = List<CartAttributObject>()
    
    internal convenience init(product_id: Int, product_name: String, product_image: String , product_code:String , product_price:Int, product_ctns:Double ,product_weight:Double,product_cbm:Double,product_max_qty:Int,product_min_qty:Int , product_current_qty:Int,store_id:Int,store_owner_id:Int , product_Inner_qty:Int = 0, cartAttributs:List<CartAttributObject>){
        
        self.init()

        self.product_id = product_id
        self.product_name = product_name
        self.product_image = product_image
        self.product_code = product_code
        
        self.product_price = product_price
        self.product_ctns = product_ctns
        self.product_weight = product_weight
        self.product_cbm = product_cbm
        self.product_max_qty = product_max_qty

        self.product_min_qty = product_min_qty
        self.product_current_qty  = product_current_qty
        self.store_id = store_id
        self.store_owner_id = store_owner_id
        self.cartAttributs = cartAttributs
        self.product_Inner_qty = product_Inner_qty

    }
    
    override class func primaryKey() -> String {
        return "product_id"
    }
}

class CartAttributObject : Object , Codable{
   
    internal convenience init(attr_id: Int = 0, attr_name: String = "", attr_image: String = "", attr_code: String = "", attr_price: Int = 0, attr_ctns: Double = 0.0, attr_weight: Int = 0, attr_cbm: Int = 0, attr_max_qty: Int = 0, attr_min_qty: Int = 0 , product_current_qty:Int = 0, store_id: Int = 0, store_owner_id: Int = 0 , product_Inner_qty:Int = 0) {
        
        self.init()

        self.attr_id = attr_id
        self.attr_name = attr_name
        self.attr_image = attr_image
        self.attr_code = attr_code
        self.attr_price = attr_price
        self.attr_ctns = attr_ctns
        self.attr_weight = attr_weight
        self.attr_cbm = attr_cbm
        self.attr_max_qty = attr_max_qty
        self.attr_min_qty = attr_min_qty
        self.product_current_qty = product_current_qty
        self.store_id = store_id
        self.store_owner_id = store_owner_id
        self.product_Inner_qty = product_Inner_qty
    }
    
    @objc dynamic var attr_id: Int = 0
    @objc dynamic var attr_name: String = ""
    @objc dynamic var attr_image: String = ""
    @objc dynamic var attr_code: String = ""
    @objc dynamic var attr_price: Int = 0
    
    @objc dynamic var attr_ctns: Double = 0.0
    @objc dynamic var attr_weight: Int = 0
    @objc dynamic var attr_cbm: Int = 0
    
    
    @objc dynamic var attr_ctns_all: Double = 0.0

    @objc dynamic var attr_weight_all: Double = 0
    @objc dynamic var attr_cbm_all: Double = 0
    
    @objc dynamic var attr_max_qty: Int = 0
    @objc dynamic var attr_min_qty: Int = 0
    @objc dynamic var product_current_qty: Int = 0
    @objc dynamic var product_Inner_qty: Int = 0 // for ctns

    @objc dynamic var store_id: Int = 0
    @objc dynamic var store_owner_id: Int = 0
    
    @objc dynamic var createdAt:Date? = Date()
    @objc dynamic var modifiedAt:Date?
    @objc dynamic var qtyExpanded = false
   
    var linkingInputInfo = LinkingObjects(fromType: CartDataObject.self, property: "cartAttributs")
    
    enum CodingKeys: String, CodingKey {
        case attr_id, attr_name, attr_image, attr_code
        
        case attr_price = "attr_price"
        case attr_ctns, attr_weight, attr_cbm, attr_ctns_all
        case attr_weight_all, attr_cbm_all, product_current_qty, store_id

        
    }
    
    override class func primaryKey() -> String {
        return "attr_id"
    }
}
