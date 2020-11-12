//
//  AuthenticationManager.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 11/11/2020.
//

import Foundation
import JWTDecode
import KeychainSwift

class AuthenticationManager {
    
    private let keychain = KeychainSwift()
    private let authTokenKey = "kAuthTokenKey"
    private let refreshTokenKey = "kRefreshTokenKey"
    
    // MARK: - Token and validity
    var token: String? {
        return keychain.get(authTokenKey)
    }
    
    var refreshToken: String? {
        return keychain.get(refreshTokenKey)
    }
    
    var tokenIsValid: Bool {
        guard let token = keychain.get(authTokenKey) else {
            return false
        }
        
        do {
            let jwt = try decode(jwt: token)
            return !jwt.expired
        }
        catch {
            // Error, just fall through
        }
        
        return false
    }
    
    // MARK: - Logging in
    
    /// Login to the service. Method calls the API the processes the response
    /// - Parameters:
    ///   - loginCredentials: The login creds
    ///   - completion: Success Or Failure of the Login, and an optional user readable error string
    func login(loginCredentials: LoginCredentials,
               completion: @escaping(Bool, String?) -> Void) {
        Api.login(loginCredentials: loginCredentials) { (response, e) in
            guard let response = response else {
                if let e = e {
                    self.handleBadResponse(error: e, completion: completion)
                    
                    return
                }
                
                // We should never get here
                completion(false, "Unable to login. Please try again later")
                return
            }
            
            // Check for the states of the response 200, 401, 500
            if response.meta.statusCode != 200 {
                completion(false, response.data.userMessage)
                
                return
            }
            
            self.handleSuccessfulResponse(response: response, completion: completion)
        }
    }
    
    func clearKeychain() {
        keychain.clear()
    }
}

/// Result handling
extension AuthenticationManager {
    private func handleSuccessfulResponse(response: LoginResponse,
                                           completion: @escaping(Bool, String?) -> Void) {
        guard let token = response.data.authToken,
              let refreshToken = response.data.refreshToken else {
            completion(false, "Server did not provide the required tokens")
            return
        }
        
        // Save the tokens
        keychain.set(token, forKey: authTokenKey)
        keychain.set(refreshToken, forKey: refreshTokenKey)
        
        completion(true, nil)
    }
    
    private func handleBadResponse(error: Api.ApiError,
                                   completion: (Bool, String?) -> Void) {
        switch error {
        case .dataEncodingError:
            completion(false, "Unable to encode username and password. Please try again")
        case .dataDecodingError:
            completion(false, "Unable to decode the server response. Please try again")
        case .callError(let message):
            completion(false, "Unexpected response from the server. \(message)")
        }
    }
}
