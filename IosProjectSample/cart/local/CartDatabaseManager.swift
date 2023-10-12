//
//  CartDatabaseManager.swift
//  LaowaiQuestions
//
//  Created by Macbook on 04/01/2023.
//  Copyright © 2023 Maged Shaheen. All rights reserved.
//

import RealmSwift

class CartDatabaseManager{
    
    static let shared = CartDatabaseManager()
    
    private let realm = try! Realm()
    
    private init() {}
    
    func delete(object: CartDataObject) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func add(object: CartDataObject) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    
    func addOrUpdateAttribute(object: CartAttributObject) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    
    // if not exist add else modify
    func addOrUpdate(object: CartDataObject) -> [CartDataObject] {
       
        try! realm.write {
            realm.add(object , update: .modified)
            
            return fetchCartProductByStoreId(storeId: object.store_id)
        }
        
    }

    func fetchCartProduct() -> [CartDataObject] {
        return Array(realm.objects(CartDataObject.self))
    }
  
    func fetchCartProductByStoreId(storeId:Int) -> [CartDataObject] {
        return Array(realm.objects(CartDataObject.self).filter("store_id == \(storeId)"))
    }
    
    func fetchCartResultByStoreId(storeId:Int) -> Results<CartDataObject> {
        return realm.objects(CartDataObject.self).filter("store_id == \(storeId)")
    }
}
