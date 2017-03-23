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
        let brightness = self.rgbBrightness(r: Double(r), g: Double(g), b: Double(b))
        if brightness < 0.65 {
            return false
        } else {
            return true
        }
    }
    
    // HSP Color Model: http://alienryderflex.com/hsp.html
    func rgbBrightness(r: Double, g: Double, b: Double) -> Double {
        return sqrt(0.299 * pow(r,2) + 0.587 * pow(g,2) + 0.114 * pow(b,2))
    }
}
