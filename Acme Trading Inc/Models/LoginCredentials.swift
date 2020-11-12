//
//  LoginCredentials.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 10/11/2020.
//

import Foundation


/// Login credentails to be passed to the Login call
struct LoginCredentials: Codable {
    let username: String
    let password: String
}
