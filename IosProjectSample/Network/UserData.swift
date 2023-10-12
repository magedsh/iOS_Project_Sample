//
//  UserData.swift
//  LaowaiQuestions
//
//  Created by Macbook on 3/29/21.
//

import Foundation


import Foundation
import UIKit

class UserData {

    static let preference = UserDefaults.standard
    
    
    
    static fileprivate let USER_ID: String = "id"
    static fileprivate let USER_NAME: String = "USER_NAME"
    static fileprivate let nick_name: String = "nick_name"
    static fileprivate let USER_EMAIL: String = "USER_EMAIL"
    static fileprivate let userphone: String = "userphone"
    static fileprivate let api_token: String = "token"
    static fileprivate let IS_LOGIN: String = "IS_LOGIN"
    static fileprivate let UUID:String = "UUID"
    static fileprivate let IS_FIRSTLAUNCH: String = "IS_FIRSTLAUNCH"

    
    
    static func setIsFirstLaunch(isLogin : Bool?)  {
        
        preference.set(isLogin, forKey: IS_FIRSTLAUNCH)
//        preference.synchronize()
    }
    
    static func getIsFirstLaunch() -> Bool {
        return preference.bool(forKey: IS_FIRSTLAUNCH)  ?? true
    }
    
    static func setIsLogin(isLogin : Bool?)  {
        
        preference.set(isLogin, forKey: IS_LOGIN)
//        preference.synchronize()

    }
    
    static func getIsLogin() -> Bool {
        return preference.bool(forKey: IS_LOGIN)
        
    }
    

    static func setUserId(userId : Int)  {
        
        preference.set(userId, forKey: USER_ID)
        preference.synchronize()

    }
    
    static func getUserId() -> Int {
        return preference.integer(forKey: USER_ID)
    }
    
    static func setUserName(userName : String )  {
        preference.set(userName, forKey: USER_NAME)
//        preference.synchronize()

    }
    
    static func getUserName() -> String {
        return preference.string(forKey: USER_NAME) ?? ""
    }
    
    static func setUserNickName(userNickName : String )  {
        preference.set(userNickName, forKey: nick_name)
//        preference.synchronize()

    }
    
    static func getUserNickName() -> String {
        return preference.string(forKey: nick_name) ?? ""
    }
    

    
    static func setUSER_EMAIL(email : String )  {
        preference.set(email, forKey: USER_EMAIL)
//        preference.synchronize()

    }
    
    static func getUSER_EMAIL() -> String {
        return preference.string(forKey: USER_EMAIL) ?? ""
    }
    
    static func setapi_token(access_token : String)  {
        
        preference.set(access_token, forKey: api_token)
//        preference.synchronize()

    }
    
    static func getApi_token() -> String {
        return preference.string(forKey: api_token) ?? ""
    }

    // MARK: - Logout
    
    func logOut(){

        UserData.setIsLogin(isLogin: false)
        UserData.setUSER_EMAIL(email: "")
        UserData.setapi_token(access_token: "")
        UserData.setUserName(userName: "")
        UserData.setUserId(userId: 0)
        
    }
    
    
}
