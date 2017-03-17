//
//  ColorShapeLayer.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/15/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

class ColorShapeLayer: CAShapeLayer {
    
    override func hitTest(_ p: CGPoint) -> ColorShapeLayer? {
        guard let shapePath = self.path,
              shapePath.contains(p) else {
                return nil
        }
        return self
    }
    
    func select() {
        self.borderColor = UIColor.red.cgColor
        self.opacity = 0.5
    }
    
    func deselect() {
        self.borderColor = UIColor.black.cgColor
        self.opacity = 1
    }

}
