//
//  LoginResponse.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 10/11/2020.
//

import Foundation

struct LoginResponse: Codable {
    let data: LoginResponseData
    let meta: ResponseMetaData
}

struct LoginResponseData: Codable {
    let userMessage: String
    let authToken: String?
    let refreshToken: String?
}

struct ResponseMetaData: Codable {
    let statusCode: Int
    let reason: String
}


