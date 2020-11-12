//
//  UIViewColor.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 11/11/2020.
//

import Foundation
import UIKit

extension UIView {
    func setLeftToRightGradientBackground(firstColor: UIColor, secondColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [secondColor.cgColor, firstColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

       layer.insertSublayer(gradientLayer, at: 0)
    }
}
