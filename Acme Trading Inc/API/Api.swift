//
//  Api.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 10/11/2020.
//

import Foundation

class Api {
    
    enum ApiError: Error {
        case dataEncodingError
        case dataDecodingError
        case callError(String)
    }
    
    private static let loginUrl = "https://ho0lwtvpzh.execute-api.us-east-1.amazonaws.com/DummyLogin"
    private static let profilesUrl = "https://ypznjlmial.execute-api.us-east-1.amazonaws.com/DummyProfileList"
    
    static func getProfileList(token: String,
                               completion: @escaping(ProfileListResponse?, ApiError?) -> Void) {
        let url = URL(string: Api.profilesUrl)!
        var request = getRequest(url: url, method: "GET")
        request.addValue(token, forHTTPHeaderField: "authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    print(String(describing: error))
                    completion(nil, ApiError.callError(error?.localizedDescription ?? "Unknown Error getting profile data"))
                    
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
                print(String(data: data, encoding: .utf8)!)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let profilesResult = try decoder.decode(ProfileListResponse.self, from: data)
                    completion(profilesResult, nil)
                    
                    return
                }
                catch {
                    completion(nil, ApiError.dataDecodingError)
                    return
                }
            }
        }
        
        task.resume()
        
    }
    
    static func login(loginCredentials: LoginCredentials,
                      completion: @escaping(LoginResponse?, ApiError?) -> Void) {
        let url = URL(string: Api.loginUrl)!
        var request = getRequest(url: url, method: "POST")
        let encoder = JSONEncoder()
        
        do {
            let bodyData = try encoder.encode(loginCredentials)
            request.httpBody = bodyData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        }
        catch {
            completion(nil, ApiError.dataEncodingError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    print(String(describing: error))
                    completion(nil, ApiError.callError(error?.localizedDescription ?? "Unknown Error logging in"))
                    
                    return
                }
//                if let httpResponse = response as? HTTPURLResponse {
//                  print(httpResponse.statusCode)
//                }
//                print(String(data: data, encoding: .utf8)!)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let loginResult = try decoder.decode(LoginResponse.self, from: data)
                    completion(loginResult, nil)
                    
                    return
                }
                catch {
                    completion(nil, ApiError.dataDecodingError)
                    return
                }
            }
        }
        
        task.resume()
    }
    
    static private func getRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url ,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        
        return request
    }
}
