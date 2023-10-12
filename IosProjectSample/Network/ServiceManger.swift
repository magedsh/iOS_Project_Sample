//
//  ServiceManger.swift
//  LaowaiQuestions
//
//  Created by Macbook on 3/29/21.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON

class ServiceManger{
  
    private init() {}
    
    public static let instance = ServiceManger()
    
    func getData<T: Decodable, E: Decodable>(url: String, method: HTTPMethod ,params: Parameters?, encoding: ParameterEncoding ,headers: HTTPHeaders? ,completion: @escaping (T?, E?, Error?)->()) {
        
        AF.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
            .validate(statusCode: 200...300)
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    guard let data = response.data else { return }
                    print("jsonDatadata \(data)")

                    do {
                        let jsonData = try JSONDecoder().decode(T.self, from: data)
                        completion(jsonData, nil, nil)
                        print("jsonData \(jsonData)")

                    } catch let jsonError {
                        print("jsonError \(jsonError)")
                    }
                    
                case .failure(let error):
                    // switch on Error Status Code
                    guard let data = response.data else {
                        completion(nil, nil, nil)
                        print("jsonDataguard error")

                        return }
                    guard let statusCode = response.response?.statusCode else {
                        completion(nil, nil, nil)
                        print("jsonDatastatus  error")

                        return }
                    switch statusCode {
                    case 400..<500:
                        do {
                            let jsonError = try JSONDecoder().decode(E.self, from: data)
                            completion(nil, jsonError, nil)
                            print("jsonError 400  \(jsonError)")

                        } catch let jsonError {
                            print(jsonError)
                            completion(nil, nil, nil)
                            print("jsonError catch  \(jsonError)")


                        }
                    default:
                        completion(nil, nil, error)
                    }
                }
            }
    }
    func logIn (email: String, password: String, completion: @escaping (_ result: LoginModel? ,_ error: LoginErrorModel? )->()){
          
        let body = ["email":email,"password":password] as [String : Any]
        
        print("body\(body)")
//        let token = "getApi_token()`"
//        let headers = ["Authorization" : "Bearer "+token+"",
//                       "Content-Type": "application/json"]
        let headers : HTTPHeaders  = ["Content-Type": "application/json" ,
                       "Accept": "application/json" ,
                       "device": "ios",
                       "lang": UserData.getAppLanguage(),
                       "token":"232423"]
        
//        print("headers\(headers)")
        AF.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse) in
             
            print("AAAAA\(response)")
            
            guard let res = response.value as? [String:Any] else {
                completion(nil,nil)
                return}
            print("loginRes = \(res)")
           guard let apiStatus = res["success"]  as? Any else {
            completion(nil,nil)

            return}
            print("apiStatus Int = \(apiStatus)")
           if apiStatus is Int{
               
                if apiStatus as! Int == 1 {
                    //   let registerModel = try? newJSONDecoder().decode(RegisterModel.self, from: jsonData)
                    
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(LoginModel.self, from: data!)
                    print("apiToken = \(result?.data?.token ?? "")")
                    print("loginresult = \(result)")

                    completion(result,nil)
                }else {
                    
                    do{
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(LoginErrorModel.self, from: data!)
//                        print("Msg = \(result?.msg ?? "")")
                        
                        
                        completion(nil,result)
                    }catch {
                        
                        print("login error  \(error)")
                        
                        completion(nil,nil)
                    }

                }
               

//               completionBlock(result,nil,nil,nil)
               
           }else{
            
            completion(nil,nil)

            
           }
    
        }
        
    }
    
    func makeOrder(type:String , user_id:Int, total_price:Double , total_ctns:Double , total_cbm:Double , total_weight:Double , store_id:Int , products:Results<CartDataObject>? , completion: @escaping (_ result: SuccessResponseModel?)->()) {

        let token = UserData.getApi_token()

        var cartProducts = [CartProduct]()
        products?.forEach { cartObject in
            
            var cartAttrs = [CartAttr]()

            cartObject.cartAttributs.forEach { cartAttr in
                                
                let cartAttr = CartAttr(attr_id: cartAttr.attr_id, attr_name: cartAttr.attr_name, attr_price: cartAttr.attr_price, attr_ctns: cartAttr.attr_ctns_all, attr_weight: cartAttr.attr_weight_all, attr_cbm: cartAttr.attr_cbm_all, attr_qty: cartAttr.product_current_qty)
                
                cartAttrs.append(cartAttr)
                
            }
            
            let cartProduct = CartProduct(product_id: cartObject.product_id, product_name: cartObject.product_name, product_qty: cartObject.product_current_qty, product_price: cartObject.product_price, product_ctns: cartObject.product_ctns_all, product_weight: cartObject.product_weight_all, product_cbm: cartObject.product_cbm_all, cartAttributs: cartAttrs)
            
            cartProducts.append(cartProduct)
        }
        
         
        var params = [
            "type":type,
            "user_id":user_id,
            "total_price": total_price,
            "total_ctns": total_ctns,
            "total_cbm": total_cbm,
            "total_weight": total_weight,
            "store_id": store_id
        ] as [String : Any]
        
        
    }
}
