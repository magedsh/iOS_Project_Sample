//
//  RegisterModel.swift
//  LaowaiQuestions
//
//  Created by Macbook on 4/11/21.
//  Copyright © 2021 Maged Shaheen. All rights reserved.
//

import Foundation

// MARK: - RegisterModel
struct RegisterModel: Codable {
    
    let data: RegisterData?
    let code: Int?
    let status: Bool?
}

// MARK: - DataClass
struct RegisterData: Codable {
    let name,email: String? /*, nickName, birth*/
//    let gender: Int?
    let /*code,*/ id: Int?
    let apiToken: String?
//    let `private`:Bool?
//    let userId:String?
    let userImage:String?

    

    enum CodingKeys: String, CodingKey {
        case name
//        case nickName = "nick_name"
        case email,/* birth, gender, code,*/ id
        case apiToken = "api_token"
        case userImage 
//        case `private` = "private"
//        case userId = "user_id"

    }
}

