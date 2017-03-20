//
//  UIColor.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/18/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

extension UIColor {
    
    /*
     Determine if color light or dark
     Adopted from: http://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
    */
    func isLight() -> Bool {
        guard let components = self.cgColor.components as [CGFloat?]?,
              let r = components[0],
              let g = components[1],
              let b = components[2] else {
            return false
        }
        // HSP Color Model: http://alienryderflex.com/hsp.html
        let brightness = sqrt(0.299 * pow(Double(r),2) + 0.587 * pow(Double(g),2) + 0.114 * pow(Double(b),2))
        if brightness < 0.65 {
            return false
        } else {
            return true
        }
    }
    
    
}
