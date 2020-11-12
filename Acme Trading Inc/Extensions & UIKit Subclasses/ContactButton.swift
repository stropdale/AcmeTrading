//
//  ContactButton.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 11/11/2020.
//

import Foundation

import UIKit

class ContactButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = UIColor.gradientColorEnd
        
        setLeftToRightGradientBackground(firstColor: UIColor.gradientColorStart,
                                         secondColor: UIColor.gradientColorEnd)
    }
}
