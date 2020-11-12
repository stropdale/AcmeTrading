//
//  Color+App.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 11/11/2020.
//

import Foundation
import UIKit

extension UIColor {
    static var backgroundColor: UIColor {
        return UIColor.init(named: "backgroundColor")!
    }
    
    static var gradientColorStart: UIColor {
        return UIColor.init(named: "gradientColorStart")!
    }
    
    static var gradientColorEnd: UIColor {
        return UIColor.init(named: "gradientColorEnd")!
    }
}
