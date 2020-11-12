//
//  LoginViewController.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 11/11/2020.
//

import UIKit

protocol LoginViewControllerDelegate {
    func completed()
}

class LoginViewController: UIViewController {
    
    public var delegate: LoginViewControllerDelegate?
    private let authManager = AuthenticationManager()
    
    private var enteredCredentials: LoginCredentials? {
        guard let user = usernameTextField.text,
              let pass = passwordTextField.text else {
            return nil
        }
        
        if user.isEmpty || pass.isEmpty {
            return nil
        }
        
        return LoginCredentials(username: user, password: pass)
    }
    
    @IBOutlet private weak var usernameTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showErrorMessage(str: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        login()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        print("Register button tapped")
    }
    
    private func login() {
        guard let credentials = enteredCredentials else {
            showErrorMessage(str: "Please enter your username and password")
            return
        }
        
        authManager.login(loginCredentials: credentials) { (success, message) in
            if success {
                self.dismiss(animated: true, completion: nil)
                self.delegate?.completed()
            }
            else {
                self.showErrorMessage(str: message)
            }
        }
    }
    
    private func showErrorMessage(str: String?) {
        guard let str = str else {
            errorView.isHidden = true
            return
        }
        
        errorLabel.text = str
        errorView.alpha = 0.0
        errorView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.errorView.alpha = 1.0
        }
    }
}
