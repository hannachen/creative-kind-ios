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
    // Properties
    var pathsBoundingBox: CGRect = .zero
    var delegate: SquareViewDelegate?
    
    
    // MARK: Overrides
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.frame = self.bounds
    }
    
    
    func layoutSquareView(container: UIView) {
        self.generateSquareFromSvg()
        self.setupTapHandler()
        self.fitGrid()
    }
    
    func fitGrid() {
        let scaleFactor = CGFloat(self.frame.width / self.pathsBoundingBox.width)
        self.layer.transform = CATransform3DMakeScale(scaleFactor, scaleFactor, 1.0)
    }
    
    func generateSquareFromSvg() {
        
        // Check for file, convert svg to paths, create svg layer
        guard let url = Bundle.main.url(forResource: "grid-default", withExtension: "svg") as URL?,
              let paths = SVGBezierPath.pathsFromSVG(at: url) as [SVGBezierPath]? else {
            return
        }
        
        for path in paths {
            
            // Make sure paths have SVG attributes and an id
            guard let svgAttributes = path.svgAttributes as [String: Any]?,
                  let id = svgAttributes["id"] as? String else {
                continue
            }
            
            // TODO: Find the big square and either:
            // - remove it
            // - group it with lines
            // - use it to set pathsBoundingBox
            if id == "lines" { // There's a rectangle in the SVG with the ID of "line", use it to figure out the size of the final layer
                self.pathsBoundingBox = path.cgPath.boundingBox
                continue // Don't add this shape to the layer or it'll get selected
            }
            
            // TODO: Find the missing lines
            
            // Create a layer for each path
            let shape = ColorShapeLayer()
            shape.setupShapeFromPath(id, path: path)
                        
            // Add shape to the layer hierarchy
            self.layer.addSublayer(shape)
        }
        
        // Notify squareViewDelegate shapes have been added?
        if let shapes = self.layer.sublayers as? [ColorShapeLayer],
           let delegate = self.delegate {
            delegate.squareDidLoad(shapes: shapes)
        }
    }
    
    func setupTapHandler() {
        let tapGestureRecognizer = SingleTouchDownGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func viewTapped(gestureRecognizer: SingleTouchDownGestureRecognizer) {
        guard let touch = gestureRecognizer.location(in: self) as CGPoint?,
              let layers = self.layer.sublayers as! [ColorShapeLayer]? else {
            return
        }
        
        for layer in layers {
            guard let hitLayer = layer.hitTest(touch) else {
                continue
            }
            if let delegate = self.delegate {
                delegate.selectShape(shape: hitLayer)
                delegate.selectDidChange()
            }
            return
        }
    }

}
