//
//  LoginViewModel.swift
//  LaowaiQuestions
//
//  Created by Macbook on 03/11/2022.
//  Copyright © 2022 Maged Shaheen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class LoginViewModel {
    
    var loadingBehavior = BehaviorRelay(value: false)
    private var checkLoginValidSubject = PublishSubject<SuccessResponseModel>()
    
    var checkLoginValidObservable:Observable<SuccessResponseModel>{
        return checkLoginValidSubject
    }
    
    
    private var appleLoginValidSubject = PublishSubject<LoginModel>()
    
    var appleLoginValidObservable:Observable<LoginModel>{
        
        return appleLoginValidSubject
    }
    
    func getCheckLoginValid()  {
        let pushyToken = UserDefaults.standard.string(forKey: "pushyToken") ?? ""
        let token = UserData.getApi_token()

        let params = [
            "token": pushyToken,
        ]
        
        let headers:HTTPHeaders  = ["lang": "en",
                       "Authorization":"Bearer \(token)"]
        let url = "\(BASE_URL)last_token"
        print("getCheckLoginValidurl \(url)")
        
        ServiceManger.instance.getData(url: url, method: .post, params: params, encoding:  JSONEncoding.default, headers: headers) { [weak self] (responseModel:SuccessResponseModel?, errorModel:TokenResponseModel?, error )in
            
            guard let self = self else {
                let responseModel = SuccessResponseModel(success: false, data: "", message: "Email Not Found")
                self?.checkLoginValidSubject.onNext(responseModel)
                return}

            if let error = error {
                // error
                print(error.localizedDescription)
                let responseModel = SuccessResponseModel(success: false, data: "", message: "Email Not Found")
                self.checkLoginValidSubject.onNext(responseModel)
                
            }else if let  errorModel = errorModel {
                
                //login error
                print(errorModel.message)
                let responseModel = SuccessResponseModel(success: false, data: "", message: "Email Not Found")
                self.checkLoginValidSubject.onNext(responseModel)
                
            }else  {
                
                guard let responseModel = responseModel else {
                    
                    let responseModel = SuccessResponseModel(success: false, data: "", message: "Email Not Found")
                    self.checkLoginValidSubject.onNext(responseModel)

                    return
                }
                
                self.checkLoginValidSubject.onNext(responseModel)
                
            }
        }
    }
    
    func loginWithApple(view:UIView , app_id:String , name:String , email:String){
        //apple_login
        let token = UserData.getApi_token()
        loadingBehavior.accept(true)
        let params = [
            "app_id":app_id,
            "name": name,
            "email":email
        ]
        print("loginWithAppleBody \(params)")

        let headers:HTTPHeaders  = ["lang": "en",
                       "Authorization":"Bearer \(token)"]
        let url = "\(BASE_URL)apple_login"
        print("apple_login \(url)")
        
        ServiceManger.instance.getData(url: url, method: .post, params: params, encoding:  JSONEncoding.default, headers: headers) { [weak self] (responseModel:LoginModel?, errorModel:TokenResponseModel?, error )in
            
            guard let self = self else {return}
            self.loadingBehavior.accept(false)
            if let error = error {
                // error
                print("error \(error.localizedDescription)")
                view.makeToast("\(error.localizedDescription )")

            }else if let  errorModel = errorModel {
                
                //login error
                print("errorModel \(errorModel.message)")
                view.makeToast("\(errorModel.message ?? "")")
            }else  {
                
                guard let responseModel = responseModel else { return}
                print("loginWithAppleResponse \(responseModel)")

                self.appleLoginValidSubject.onNext(responseModel)
                
            }
        }
    }
}
