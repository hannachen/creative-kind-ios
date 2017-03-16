//
//  TriangleShapeLayer
//  creative-kind
//
//  Created by Hanna Chen on 3/14/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

class TriangleShapeLayer: CAShapeLayer {
    
    var trianglePath: UIBezierPath?
    
    override func hitTest(_ p: CGPoint) -> TriangleShapeLayer? {
        guard let trianglePath = self.trianglePath as UIBezierPath?,
              trianglePath.cgPath.contains(p) else {
            return nil
        }
        return self
    }
    
    func makeTriangle(position: CGPoint, size: Float, flip: Bool = false, reverse: Bool = false) {
        
        // Styles
        if reverse {
            self.fillColor = UIColor.blue.cgColor
            print("reverse...")
        } else {
            self.fillColor = UIColor.red.cgColor
        }
        self.strokeColor = UIColor.white.cgColor
        self.lineWidth = 1
        
        let triangleSize = CGFloat(size)
        let trianglePath = UIBezierPath()
        let firstPoint: CGPoint = self.firstPoint(position: position, size: triangleSize, flip: flip, reverse: reverse)
        let secondPoint: CGPoint = self.secondPoint(position: position, size: triangleSize, flip: flip, reverse: reverse)
        let thirdPoint: CGPoint = self.thirdPoint(position: position, size: triangleSize, flip: flip, reverse: reverse)
        trianglePath.move(to: firstPoint) // point #1
        trianglePath.addLine(to: secondPoint) // point #2
        trianglePath.addLine(to: thirdPoint) // point #3
        trianglePath.close()
        self.trianglePath = trianglePath
        
        // Constraints and position
        self.frame = CGRect(origin: position, size: CGSize(width: triangleSize, height: triangleSize))
        self.bounds = trianglePath.bounds
        self.path = trianglePath.cgPath
    }
    
    func firstPoint(position: CGPoint, size: CGFloat, flip: Bool = false, reverse: Bool = false)-> CGPoint {
        guard let firstPosition = position as CGPoint?,
              let triangleSize = size as CGFloat? else {
                return CGPoint(x: CGFloat(0), y: CGFloat(0))
        }
        
        if reverse {
            /*
             Flip: *   *  | Normal: x   *
                          |
                   x   *  |         *   *
             */
            return flip ? CGPoint(x: firstPosition.x, y: firstPosition.y + triangleSize) : firstPosition
        } else {
            /*
             Position: x   *
             
                       *   *
             */
            return firstPosition
        }
    }
    
    func secondPoint(position: CGPoint, size: CGFloat, flip: Bool = false, reverse: Bool = false)-> CGPoint {
        guard let secondPosition = position as CGPoint?,
              let triangleSize = size as CGFloat? else {
            return CGPoint(x: CGFloat(0), y: CGFloat(0))
        }
        
        if reverse {
            /*
             Flip: *   *  | Normal: *   *
                          |
                   *   x  |         x   *
              */
            if flip {
                self.fillColor = UIColor.green.cgColor
            }
            return flip ? CGPoint(x: secondPosition.x + triangleSize, y: secondPosition.y + triangleSize) : CGPoint(x: secondPosition.x, y: secondPosition.y + triangleSize)
        } else {
            /*
             Flip: *   x  | Normal: *   *
                          |
                   *   *  |         x   *
             */
            if flip {
                self.fillColor = UIColor.orange.cgColor
            }
            return flip ? CGPoint(x: secondPosition.x + triangleSize, y: secondPosition.y) : CGPoint(x: secondPosition.x, y: secondPosition.y + triangleSize)
        }
    }
    
    func thirdPoint(position: CGPoint, size: CGFloat, flip: Bool = false, reverse: Bool = false)-> CGPoint {
        guard let thirdPosition = position as CGPoint?,
              let triangleSize = size as CGFloat? else {
                return CGPoint(x: CGFloat(0), y: CGFloat(0))
        }
        
        
        if reverse {
            /*
             Position: *   *
                       
                       x   *
             */
            return CGPoint(x: thirdPosition.x + triangleSize, y: thirdPosition.y)
        } else {
            /*
             Position: *   x
             
                       *   *
             */
            return CGPoint(x: thirdPosition.x + triangleSize, y: triangleSize)
        }
    }
    
}
