//
//  LoginErrorModel.swift
//  LaowaiQuestions
//
//  Created by Macbook on 4/11/21.
//  Copyright © 2021 Maged Shaheen. All rights reserved.
//

import Foundation
// MARK: - LoginErrorModel
struct LoginErrorModel: Codable {
    let success: Bool?
    let data: String?
    let message: String?
}
