//
//  ViewController.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/14/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit
import PocketSVG

class ViewController: UIViewController {
    // Outlets
    @IBOutlet var squareView: UIView!
    
    // Properties
    let gridColumns: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.cancelsTouchesInView = false
        self.squareView.addGestureRecognizer(tapGestureRecognizer)
        self.squareView.isUserInteractionEnabled = true
        self.squareView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        
        self.generateSquareFromSvg()
        
    }
    
    override func viewDidLayoutSubviews() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateSquareFromSvg() {
        
//        if let resourceUrl = Bundle.main.url(forResource: "grid-default", withExtension: "svg") as URL? {
//            if FileManager.default.fileExists(atPath: resourceUrl.path) {
//                print("file found")
//            }
//        }
        
        guard let url = Bundle.main.url(forResource: "grid-default", withExtension: "svg") as URL?,
              let paths = SVGBezierPath.pathsFromSVG(at: url) as [SVGBezierPath]? else {
            return
        }
        
        for path in paths {
            
            // Create a layer for each path
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            
            // Default Settings
            var strokeWidth = CGFloat(0.5)
            var strokeColor = UIColor.black.cgColor
            var fillColor = UIColor.white.cgColor
            
            // Inspect the SVG Path Attributes
            print("path.svgAttributes = \(path.svgAttributes)")
            
            if let strokeValue = path.svgAttributes["stroke-width"] {
                if let strokeN = NumberFormatter().number(from: strokeValue as! String) {
                    strokeWidth = CGFloat(strokeN)
                }
            }
            
            if let strokeValue = path.svgAttributes["stroke"] {
                strokeColor = strokeValue as! CGColor
            }
            
            if let fillColorVal = path.svgAttributes["fill"] {
                fillColor = fillColorVal as! CGColor
            }
            
            // Set its display properties
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            layer.fillColor = fillColor
            
            // Add it to the layer hierarchy
            self.squareView.layer.addSublayer(layer)
        }
        
//        if let paths = SVGKImage.imageWithContentsOfFile("grid-default") as SVGBezierPath {
//            print("paths \(paths)")
//        }
        /*
        for(SVGBezierPath *path in [SVGBezierPath pathsFromSVGNamed:@"grid-default"]) {
            // Create a layer for each path
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.path = path.CGPath;
            
            // Set its display properties
            layer.lineWidth   = 4;
            layer.strokeColor = [path.svgAttributes[@"stroke"] ?: [UIColor blackColor] CGColor];
            layer.fillColor   = [path.svgAttributes[@"fill"] ?: [UIColor redColor] CGColor];
            
            // Add it to the layer hierarchy
            [self.view.layer addSublayer:layer];
        }
        */
    }
    
    func generateSquare() {
        let triangleSize: Float = Float(self.squareView.frame.size.width) / (Float(self.gridColumns) / 2)
        let midGrid: Int = self.gridColumns / 2
        
        print("container width: \(self.squareView.frame.size.width)")
        
        var rowIndex: Int = 0
        
        for row in 1...self.gridColumns {
            
            var columnIndex: Int = 0
            let y: CGFloat = CGFloat(Float(rowIndex) * triangleSize)
            var reverse: Bool = row > midGrid
            
            // Past half-way point
            if row > midGrid {
                reverse = true
                if row != midGrid + 1 {
                    rowIndex += row % 2 == 0 ? 1 : 0
                }
            } else {
                rowIndex += row % 2 == 0 ? 1 : 0
            }
            
            for col in 1...self.gridColumns {
                
                let triangle: TriangleShapeLayer = TriangleShapeLayer()
                let x: CGFloat = CGFloat(Float(columnIndex) * triangleSize)
                let position: CGPoint = CGPoint(x: x, y: y)
                
                let flip: Bool = col % 2 == 0
                
                // Past half-way point
                if col > midGrid {
                    reverse = true
                    // Half-way point, reverse triangle direction
                    if col != midGrid + 1 {
                        columnIndex += col % 2 == 0 ? 1 : 0
                    }
                } else {
                    reverse = false
                    columnIndex += col % 2 == 0 ? 1 : 0
                }
                
                triangle.makeTriangle(position: position, size: triangleSize, flip: flip, reverse: reverse)
                
                self.squareView.layer.addSublayer(triangle)
            }
            
        }
    }
    
    func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        guard let touch = gestureRecognizer.location(in: self.squareView) as CGPoint?,
              let layers = self.squareView.layer.sublayers as [CALayer]? else {
            return
        }
        print("View tapped \(touch)")
        for layer in layers {
            if let hitLayer = layer.hitTest(touch) {
                print("Transform layer tapped! \(hitLayer)")
                hitLayer.opacity = 0.5
            } else {
                layer.opacity = 1
            }
        }
    }

}

