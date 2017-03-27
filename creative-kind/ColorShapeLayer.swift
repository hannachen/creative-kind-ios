//
//  ColorShapeLayer.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/15/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit
import PocketSVG
import DynamicColor

class ColorShapeLayer: CAShapeLayer {
    // Properties
    
    /* The unique ID of the shape, used whe saving data */
    var id: String?
    
    /* The select state of this shape. Defaults to false. */
    var selected: Bool = false
    
    /* Fill color of this shape */
    var color: UIColor?
    
    /* The index of this colour within a palette of colours */
    var colorIndex: Int?
    
    /* Mimimum contrast between the fill color and selected border color. */
    var contrastThreshold: CGFloat = 1.25
    
    
    // MARK: Overrides
    
    override func hitTest(_ p: CGPoint) -> ColorShapeLayer? {
        guard let shapePath = self.path,
              shapePath.contains(p) else {
            return nil
        }
        return self
    }
    
    func setupShapeFromPath(_ id: String, path: SVGBezierPath) -> Void {
        
        self.id = id
        
        // Constraints and position
        self.frame = path.cgPath.boundingBox
        self.bounds = path.bounds
        self.path = path.cgPath
        
        // Combine paths to figure out the final dimensions of the layer (HELP there's got to be a better way?)
//        self.pathsBoundingBox = self.pathsBoundingBox.union(path.cgPath.boundingBox)
        
        // Default Settings
        var strokeWidth = CGFloat(0.5)
        var strokeColor = UIColor.lightGray.cgColor
        var fillColor = UIColor.white.cgColor
        
        // Inspect the SVG Path Attributes
//        print("path.svgAttributes = \(path.svgAttributes)")
        
        // Try reading original svg path styles
        if let strokeValue = path.svgAttributes["stroke-width"] as? String,
            let strokeN = NumberFormatter().number(from: strokeValue) {
            strokeWidth = CGFloat(strokeN)
        }
        if let strokeValue = path.svgAttributes["stroke"] {
            strokeColor = strokeValue as! CGColor
        }
        if let fillColorVal = path.svgAttributes["fill"] {
            fillColor = fillColorVal as! CGColor
        }
        
        // Set display properties
        self.borderWidth = 0
        self.lineWidth = strokeWidth
        self.strokeColor = strokeColor
        self.fillColor = fillColor
    }
    
    func toggle() -> Bool {
        if self.selected {
            self.deselect()
        } else {
            self.select()
        }
        return self.selected
    }
    
    func select() -> Void {
        self.selected = true
        self.lineWidth = 1.5
        self.opacity = 0.9
        self.zPosition = 1
        
        // Set color
        self.setBorderColor()
    }
    
    func deselect() -> Void {
        self.selected = false
        self.lineWidth = 0.5
        self.opacity = 1
        self.zPosition = 0
        self.strokeColor = UIColor.lightGray.cgColor
    }
    
    func applyColor(_ color: UIColor, index: Int) -> Void {
        // Apply the color
        self.fillColor = color.cgColor
        self.setBorderColor()
        
        // Save color data
        self.color = color
        self.colorIndex = index
    }
    
    /* Determine border color (default: darkGray, low contrast: adjusted Hue) */
    func getBorderColor() -> UIColor {
        let defaultColor = UIColor.darkGray
        
        guard let color = self.color,
              let contrastRatio = color.contrastRatio(with: defaultColor) as CGFloat?, // Compare contrast
              contrastRatio < self.contrastThreshold else {
            return defaultColor
        }
        return color.adjustedHue(amount: 80)
    }
    
    func setBorderColor() -> Void {
        let borderColor = self.getBorderColor()
        
        // Set color
        self.strokeColor = borderColor.cgColor
    }
}
