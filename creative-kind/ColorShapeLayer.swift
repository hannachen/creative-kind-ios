//
//  ColorShapeLayer.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/15/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

class ColorShapeLayer: CAShapeLayer {
    
    var id: String?
    var selected: Bool = false
    
    override func hitTest(_ p: CGPoint) -> ColorShapeLayer? {
        guard let shapePath = self.path,
              shapePath.contains(p) else {
                return nil
        }
        return self
    }
    
    func selectToggle() {
        if self.selected {
            self.deselect()
        } else {
            self.select()
        }
    }
    
    func select() {
        self.selected = true
        self.lineWidth = 1
        self.strokeColor = UIColor.red.cgColor
        self.opacity = 0.5
    }
    
    func deselect() {
        self.selected = false
        self.lineWidth = 0.5
        self.strokeColor = UIColor.black.cgColor
        self.opacity = 1
    }

}
