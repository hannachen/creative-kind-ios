//
//  UIColor.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/18/17.
//  Adopted from: https://gist.github.com/mbigatti/c6be210a6bbc0ff25972
//

import UIKit

extension UIColor {
    
    /**
     Returns a lighter color by the provided percentage
     
     :param: lighting percent percentage
     :returns: lighter UIColor
     */
    func lighterColor(percent: Double) -> UIColor {
        return colorWithBrightnessFactor(CGFloat(1 + percent));
    }
    
    /**
     Returns a darker color by the provided percentage
     
     :param: darking percent percentage
     :returns: darker UIColor
     */
    func darkerColor(percent: Double) -> UIColor {
        return colorWithBrightnessFactor(CGFloat(1 - percent));
    }
    
    /**
     Return a modified color using the brightness factor provided
     
     :param: factor brightness factor
     :returns: modified color
     */
    func colorWithBrightnessFactor(_ factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self
        }
    }
    
    /*
     Adopted from: http://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
    */
    func isLight() -> Bool {
        guard let components = self.cgColor.components as [CGFloat?]?,
              let r = components[0],
              let g = components[1],
              let b = components[2] else {
            return false
        }
        let brightness = ((r * 299) + (g * 587) + (b * 114)) / 1000
        if brightness < 0.5 {
            return false
        } else {
            return true
        }
    }
}
