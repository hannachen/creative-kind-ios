//
//  ViewController.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/14/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

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
        
        let triangleSize: Float = Float(self.squareView.frame.size.width) / (Float(self.gridColumns) / 2)
        
        print("container width: \(self.squareView.frame.size.width)")
        
        var columnIndex: Int = 0
        let midColumn: Int = self.gridColumns / 2
        
        for index in 1...self.gridColumns {
            
            let triangle: ColorShapeLayer = ColorShapeLayer()
            let x: CGFloat = CGFloat(Float(columnIndex) * triangleSize)
            let position: CGPoint = CGPoint(x: x, y: 0)
            
            let flip: Bool = index % 2 == 0
            var reverse: Bool = index > self.gridColumns / 2
            
            // Past half-way point
            if index > midColumn {
                reverse = true
                // Half-way point, reverse triangle direction
                if index != midColumn + 1 {
                    columnIndex += index % 2 == 0 ? 1 : 0
                }
            } else {
                columnIndex += index % 2 == 0 ? 1 : 0
            }
            
            triangle.makeTriangle(position: position, size: triangleSize, flip: flip, reverse: reverse)
            
            self.squareView.layer.addSublayer(triangle)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

