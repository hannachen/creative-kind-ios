//
//  ColorShapeLayer.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/15/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

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
    
    
    func selectToggle() {
        if self.selected {
            self.deselect()
        } else {
            self.select()
        }
    }
    
    func select() {
        self.selected = true
        self.lineWidth = 1.5
        self.strokeColor = UIColor.darkGray.cgColor
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
