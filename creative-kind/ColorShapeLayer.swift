//
//  ColorShapeLayer.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/15/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit
import PocketSVG

class ColorShapeLayer: CAShapeLayer {
    // Properties
    var id: String?
    var selected: Bool = false
    var color: UIColor?
    
    
    // MARK: Overrides
    
    override func hitTest(_ p: CGPoint) -> ColorShapeLayer? {
        guard let shapePath = self.path,
              shapePath.contains(p) else {
            return nil
        }
        return self
    }
    
    func setupShapeFromPath(_ id: String, path: SVGBezierPath) {
        
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
    
    func selectToggle() -> Bool {
        if self.selected {
            self.deselect()
        } else {
            self.select()
        }
        return self.selected
    }
    
    func select() {
        self.selected = true
        self.lineWidth = 1.5
        self.strokeColor = UIColor.darkGray.cgColor // TODO: Use color contrast to find a suitable selected border color
        self.opacity = 0.9
        self.zPosition = 1
    }
    
    func deselect() {
        self.selected = false
        self.lineWidth = 0.5
        self.strokeColor = UIColor.lightGray.cgColor
        self.opacity = 1
        self.zPosition = 0
    }
    
    func applyColor(_ color: UIColor) {
        self.color = color
        self.fillColor = color.cgColor
    }

}
