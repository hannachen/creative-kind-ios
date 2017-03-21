//
//  Square.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/20/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import Foundation
import UIKit

class Square {
    var shapes: [ColorShapeLayer]
    
    init(shapes: [ColorShapeLayer]) {
        self.shapes = shapes
    }
    
    func select(_ shape: ColorShapeLayer) -> Void {
        self.findShape(shape)?.selected = true
    }
    
    func deselect(_ shape: ColorShapeLayer) -> Void {
        self.findShape(shape)?.selected = false
    }
    
    func findShape(_ shape: ColorShapeLayer) -> ColorShapeLayer? {
        if let index = self.shapes.index(of: shape) {
            return self.shapes[index]
        }
        return nil
    }
    
    func selectedShapes() -> [ColorShapeLayer]? {
        return self.shapes.filter{ $0.selected }
    }
    
    func clearSelected() -> Void {
        guard let selectedShapes = self.selectedShapes() else {
            return
        }
        for shape in selectedShapes {
            shape.deselect()
        }
    }
    
    /**
     Apply color to all selected shapes
     
     :param: color
     */
    func applyColor(_ color: UIColor) -> Void {
        guard let selectedShapes = self.selectedShapes() else {
            return
        }
        for shape in selectedShapes {
            shape.applyColor(color)
        }
    }
    
    func getData() -> [CAShapeLayer] {
        return self.shapes
    }
}
