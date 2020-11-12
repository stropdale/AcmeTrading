//
//  ListViewModel.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 11/11/2020.
//

import Foundation

class ListViewModel {
    private let authManager = AuthenticationManager()
    private var profiles: [ProfileItem]?
    private var imageCache: ImageCache?
    
    private var rows: [ProfileRow]?
    
    class ProfileRow {
        let model: ProfileItem
        let imgCache: ImageCache.ImageItem
        
        init(model: ProfileItem, cache: ImageCache.ImageItem) {
            self.model = model
            self.imgCache = cache
        }
    }
    
    var sortedProfiles: [ProfileRow]? {
        guard let rows = rows else {
            return nil
        }
        
        return rows.sorted{$0.model.numRatings > $1.model.numRatings}
    }
    
    var validToken: Bool {
        return authManager.tokenIsValid
    }
    
    /// Load the data
    /// - Parameter completed: Bool is success or fail. String is an error message if there is a fail
    func load(completion: @escaping(Bool, String?) -> Void) {
        if let token = authManager.token {
            Api.getProfileList(token: token) { (response, error) in
                guard let response = response else {
                    if let error = error {
                        self.handleBadResponse(error: error, completion: completion)
                        return
                    }
                    
                    // We should never get here
                    completion(false, "Unable to get profile info. Please try again later")
                    return
                }
                
                if response.meta.statusCode != 200 {
                    completion(false, response.data.userMessage)
                    return
                }
                
                if let profiles = response.data.profiles, let imgUrls = response.data.profileImageUrls  {
                    let cache = ImageCache.init(imageUrls: imgUrls)
                    var pRows = [ProfileRow]()
                    
                    for (index, profile) in profiles.enumerated() {
                        let img = cache.imageItems[index]
                        pRows.append(ProfileRow.init(model: profile, cache: img))
                    }
                    
                    self.rows = pRows
                    completion(true, nil)
                }
            }
        }
    }
    
    private func handleBadResponse(error: Api.ApiError,
                                   completion: (Bool, String?) -> Void) {
        switch error {
        case .dataEncodingError:
            completion(false, "Encoding error. Please try again")
        case .dataDecodingError:
            completion(false, "Unable to decode the server response. Please try again")
        case .callError(let message):
            completion(false, "Unexpected response from the server. \(message)")
        }
    }
}
