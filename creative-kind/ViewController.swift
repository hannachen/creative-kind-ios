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
    @IBOutlet var squareContainerView: UIView!
    
    // Properties
    let gridColumns: Int = 20
    var squareView: SquareView = SquareView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.squareView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.cancelsTouchesInView = false
        self.squareView.addGestureRecognizer(tapGestureRecognizer)
        self.squareView.isUserInteractionEnabled = true
        self.squareView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
    }
    
    override func viewDidLayoutSubviews() {
        self.squareView.generateSquareFromSvg()
        self.squareView.fitGrid(frame: self.squareContainerView.frame)
    }
    
    override func viewWillLayoutSubviews() {
        self.squareView.frame = self.squareContainerView.frame
        self.squareView.bounds = self.squareContainerView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
              let layers = self.squareView.layer.sublayers as! [ColorShapeLayer]? else {
            return
        }
        for layer in layers {
            if let hitLayer = layer.hitTest(touch) {
                print("Transform layer tapped! \(hitLayer)")
                hitLayer.select()
            } else {
                layer.deselect()
            }
        }
    }

}

