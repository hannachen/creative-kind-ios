//
//  SquareView.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/15/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit
import PocketSVG

class SquareView: UIView {
    
    var pathsBoundingBox: CGRect = CGRect.zero
    
    func fitGrid(frame: CGRect) {
        
        let scaleFactor = CGFloat(self.frame.width / self.pathsBoundingBox.width)
        self.layer.transform = CATransform3DMakeScale(scaleFactor, scaleFactor, 1.0)
        
        // Re-position the grid
        self.frame = frame
        self.layer.frame = frame
    }
    
    func generateSquareFromSvg() {
        
        // Check for file, convert svg to paths, create svg layer
        guard let url = Bundle.main.url(forResource: "grid-default", withExtension: "svg") as URL?,
              let paths = SVGBezierPath.pathsFromSVG(at: url) as [SVGBezierPath]? else {
            return
        }
        
        for path in paths {
            
            // Create a layer for each path
            let shape = ColorShapeLayer()
            
            // Constraints and position
            shape.frame = path.cgPath.boundingBox
            shape.bounds = path.bounds
            shape.path = path.cgPath
            
            // Combine paths to figure out the final dimensions of the layer (HELP there's got to be a better way?)
            self.pathsBoundingBox = self.pathsBoundingBox.union(path.cgPath.boundingBox)
            
            // Default Settings
            var strokeWidth = CGFloat(0.5)
            var strokeColor = UIColor.black.cgColor
            var fillColor = UIColor.white.cgColor
            
            // Inspect the SVG Path Attributes
            print("path.svgAttributes = \(path.svgAttributes)")
            
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
            shape.lineWidth = strokeWidth
            shape.strokeColor = strokeColor
            shape.fillColor = fillColor
            
            // Add shape to the layer hierarchy
            self.layer.addSublayer(shape)
        }
        
    }

}
