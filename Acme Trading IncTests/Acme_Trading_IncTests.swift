//
//  Acme_Trading_IncTests.swift
//  Acme Trading IncTests
//
//  Created by Richard Stockdale on 10/11/2020.
//

import XCTest
@testable import Acme_Trading_Inc

class Acme_Trading_IncTests: XCTestCase {

    let authManager = AuthenticationManager()
    
    override func setUpWithError() throws {
       
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testKeyChainCleared() throws {
        authManager.clearKeychain()
        let token = authManager.token
        XCTAssert(token == nil, "No token should be returned")
    }

    func testLoginWithGoodCreds() throws {
        let exp = expectation(description: "Check login was successful")
        var loginSuccess = false
        
        let creds = LoginCredentials(username: "user@morpheustest.com", password: "Password1")
        authManager.login(loginCredentials: creds) { (success, errorMessage) in
            loginSuccess = success
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssert(loginSuccess, "Login should succeed")
        }
    }
    
    func testTokenPresent() throws {
        let token = authManager.token
        XCTAssert(token != nil, "Token should be returned")
    }
}
