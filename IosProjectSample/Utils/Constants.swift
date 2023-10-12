//
//  Constants.swift
//  LaowaiQuestions
//
//  Created by Macbook on 3/29/21.
//

import Foundation



let BASE_URL = "https://xxxxxxxxxxxxxx.com/api/"
let URL_LOGIN = "\(BASE_URL)login"
typealias CompletionHandle = (_ success: Bool)->()
let HEADER = [ "Content-Type": "application/json; charset=utf-8", "Accept": "application/json; charset=utf-8"]
let BEARER_HEADER = [
    "Content-Type": "application/json; charset=utf-8",
    "Accept": "application/json; charset=utf-8",
    "Authorization": "Bearer \(UserData.getApi_token())"]
