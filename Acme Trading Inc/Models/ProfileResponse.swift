//
//  ProfileResponse.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 11/11/2020.
//

import Foundation
import UIKit

struct ProfileListResponse: Codable {
    let data: ProfileListResponseData
    let meta: ResponseMetaData
}

struct ProfileListResponseData: Codable {
    let userMessage: String
    let profiles: [ProfileItem]?
    
    var profileImageUrls: [String]? {
        guard let profiles = profiles else {
            return nil
        }
        
        return profiles.map { ($0.profileImage) }
    }
}

struct ProfileItem: Codable {
    let name: String
    let starLevel: Int
    let distanceFromUser: String
    let numRatings: Int
    let enabled: Bool
    let profileImage: String
}
