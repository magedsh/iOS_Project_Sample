//
//  RegisterErrorModel.swift
//  LaowaiQuestions
//
//  Created by Macbook on 4/11/21.
//  Copyright © 2021 Maged Shaheen. All rights reserved.
//

import Foundation

// MARK: - RegisterModel
struct RegisterErrorModel: Codable {
    let message: String?
    let errors: Errors?
}

// MARK: - Errors
struct Errors: Codable {
    let email: [String]?
}
