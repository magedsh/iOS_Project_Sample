//
//  loginResponseModel.swift
//  LaowaiQuestions
//
//  Created by Macbook on 4/7/21.
//  Copyright © 2021 Maged Shaheen. All rights reserved.
//

import Foundation

// MARK: - LoginResponseModel
struct LoginResponseModel: Codable {
    let token: String
    let id: Int
    
    var c  = 0
    
    
    mutating func cc()  {
        self.c = 1
    }
}
