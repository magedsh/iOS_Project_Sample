//
//  LoginModel.swift
//  LaowaiQuestions
//
//  Created by Macbook on 4/11/21.
//  Copyright © 2021 Maged Shaheen. All rights reserved.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let success: Bool?
    let message: String?
    let data: MyDataClass?
}

// MARK: - DataClass
struct MyDataClass: Codable {
    let token: String?
    let userData: MUserData?
}

// MARK: - UserData
struct MUserData: Codable {
    let id: Int?
    let lastLogin: String?
    let isSuperuser: Int?
    let username, firstName, lastName: String?
    let isStaff, isActive: Int?
    let dateJoined, photo, email: String?
    let bio:String?
    let resetPassCode,uuid: String?
    let resetPassCodeAttemps, emailVerified: Int?
    let verifyMailCode, name: String?
    let likes, usefuls, showMyQuestions, showMyFollowupQuestions: Int?
    let defaultLangID, socialType, accountVerified: Int?
    let createdAt: String?
    let updatedAt: String?
    let `private`:Int?
    var usefulsCount:Int?
    let followed:Bool?
    let image_url:String?
    //
    var friend_ship:Bool?
    var have_friend_request:Bool?
    var sent_friend_request:Bool?
    var friends_count:Int?
    var replys_useful_count:Int?
    //
    var phone:String?
    var phone_code:String?
    var email_code:String?
    var new_user:Int?
    var phone_verify:Int?
    var email_verify:Int?
  
    var store:Bool?
    var store_id:Int?
    var account_type:String?
    var country_code:String?
    var disable_account:Int?

    enum CodingKeys: String, CodingKey {
        case id
        case lastLogin = "last_login"
        case isSuperuser = "is_superuser"
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case isStaff = "is_staff"
        case isActive = "is_active"
        case dateJoined = "date_joined"
        case photo, email
        case resetPassCode = "reset_pass_code"
        case resetPassCodeAttemps = "reset_pass_code_attemps"
        case emailVerified = "email_verified"
        case verifyMailCode = "verify_mail_code"
        case name, likes, usefuls
        case showMyQuestions = "show_my_questions"
        case showMyFollowupQuestions = "show_my_followup_questions"
        case defaultLangID = "default_lang_id"
        case socialType = "social_type"
        case accountVerified = "account_verified"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case `private` =  "private"
        case uuid = "uuid"
        case usefulsCount = "usefuls_count"
        case followed
        case bio
        //
        case image_url = "image_url"
        //
        case friend_ship = "friend_ship"
        case have_friend_request = "have_friend_request"
        case sent_friend_request = "sent_friend_request"
        case friends_count = "friends_count"
        case replys_useful_count = "replys_useful_count"
        //
        case phone = "phone"
        case phone_code = "phone_code"
        case email_code = "email_code"
        case new_user = "new_user"
        case phone_verify = "phone_verify"
        case email_verify = "email_verify"
        
        case store
        case store_id = "store_id"
        case account_type
        case country_code = "country_code"
        case disable_account = "disable_account"
    }
}

// MARK: - Avatar
struct Avatar: Codable {
    var id: Int = 0
    var type: String = ""
    var url: String = ""
}
//
// MARK: - City
struct EditeCity: Codable {
    let id: Int
    let name: String
    let state: EditState
}
// MARK: - State
struct EditState: Codable {
    let id: Int
    let name: String
    let country: EditCountry
}

// MARK: - Country
struct EditCountry: Codable {
    let id: Int
    let name: String
}
