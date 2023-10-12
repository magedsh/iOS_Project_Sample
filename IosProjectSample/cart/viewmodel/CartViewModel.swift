//
//  CartViewModel.swift
//  LaowaiQuestions
//
//  Created by Macbook on 04/01/2023.
//  Copyright © 2023 Maged Shaheen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RealmSwift
import RxDataSources

struct SectionOfCustomData {
  var header: String
  var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
  typealias Item = CartDataObject

   init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}

typealias SectionOfPost = SectionModel<String,CartDataObject>

class CartViewModel {
    
//    CartDatabaseManager
    var sendToSellerLoadingBehavior = BehaviorRelay<Bool>(value: false)

    private var cartSectionSubject = PublishSubject<[SectionOfPost]>()
    private var cartSubject = PublishSubject<[CartDataObject]>()
    private var cartSubjectResult = PublishSubject<Results<CartDataObject>>()
    private var sendToSellerObject = PublishSubject<SuccessResponseModel>()

    var sendToSellerObservable:Observable<SuccessResponseModel>{
        return sendToSellerObject
    }
    var cartObservable:Observable<[CartDataObject]>{
        return cartSubject
    }
    var cartResultObservable:Observable<Results<CartDataObject>>{
        return cartSubjectResult
    }
    var cartSectionObservable:Observable<[SectionOfPost]>{
        return cartSectionSubject
    }
    
    func getCartFromDB(storeId:Int) {
        let cartDataObject =  CartDatabaseManager.shared.fetchCartProductByStoreId(storeId: storeId)
        cartSubject.onNext(cartDataObject)
        cartSectionSubject.onNext([SectionOfPost(model: "", items: cartDataObject)])
    }
    
    func getCartResultFromDB(storeId:Int) {
        let cartDataObject =  CartDatabaseManager.shared.fetchCartResultByStoreId(storeId: storeId)
        
        cartSubjectResult.onNext(cartDataObject)

//        if (!cartDataObject.isEmpty) {
//            cartSubject.onNext(cartDataObject)
//        }

    }
    
    func addOrUpdateProduct(productData:CartDataObject)  {
        
        cartSubject.onNext( CartDatabaseManager.shared.addOrUpdate(object: productData) )
        
    }
    
    func deleteProduct(productData:CartDataObject) {
        
        CartDatabaseManager.shared.delete(object: productData)
        
    }
    
    func addAttribute(attribute:CartAttributObject) {
        
        CartDatabaseManager.shared.addOrUpdateAttribute(object: attribute)
        
    }
    
    
    func deleteAttribute (attribute:CartAttributObject){
        
    }

    func makeOrder(type:String , user_id:Int,total_price:Double , total_ctns:Double , total_cbm:Double , total_weight:Double , store_id:Int , products:Results<CartDataObject>?)  {

        sendToSellerLoadingBehavior.accept(true)
        
        ServiceManger.instance.makeOrder(type: type ,user_id: user_id,total_price: total_price, total_ctns: total_ctns, total_cbm: total_cbm, total_weight: total_weight, store_id: store_id, products: products) { response in
            self.sendToSellerLoadingBehavior.accept(false)

            if (response != nil){
                guard let responseModel = response else { return}
                
                self.sendToSellerObject.onNext(responseModel)
            }else {
                
                let resp = SuccessResponseModel(success: false, data: "Something went wronge", message: "Something went wronge")
                self.sendToSellerObject.onNext(response ?? resp)

            }
        }
        
    }
}

struct CartProduct :Codable{
    
    var product_id: Int = 0
    var product_name: String = ""
    var product_qty: Int = 0
    var product_price: Int = 0
    var product_ctns: Double = 0.0
    var product_weight: Double = 0
    var product_cbm: Double = 0
    
    var cartAttributs:[CartAttr] = [CartAttr]()
    enum CodingKeys: String, CodingKey {
           case product_id = "product_id"
           case product_name = "product_name"
           case product_qty = "product_qty"
        
        case product_price = "product_price"
        case product_ctns = "product_ctns"
        case product_weight = "product_weight"
        case product_cbm = "product_cbm"

        case cartAttributs = "cartAttributs"

       }
}

struct CartAttr  :Codable{
    var attr_id: Int = 0
    var attr_name: String = ""
    var attr_price: Int = 0
    var attr_ctns: Double = 0.0
    var attr_weight: Double = 0
    var attr_cbm: Double = 0
    var attr_qty = 0
}

struct MakeOrderModel: Codable {
    let total_price: Double
    let total_ctns: Double
    let total_cbm: Double
    let total_weight: Double
    let store_id: Int?
    let products: [CartDataObject]?
}
