//
//  RoundImageView.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 12/11/2020.
//

import Foundation
import UIKit

extension UIImage {
    func roundImage() -> UIImage? {
        let newImage = self.copy() as! UIImage
        let cornerRadius = self.size.height/2
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
        let bounds = CGRect(origin: CGPoint(x: 0,y :0), size: self.size)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        newImage.draw(in: bounds)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}
