//
//  LoginTextField.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 11/11/2020.
//

import Foundation
import UIKit

class LoginTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 5)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func setup() {
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
        backgroundColor = UIColor.white
    }
}
