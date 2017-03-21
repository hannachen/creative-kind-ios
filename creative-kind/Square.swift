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
    var selectedShapes: [ColorShapeLayer] = []
    
    init(shapes: [ColorShapeLayer]) {
        self.shapes = shapes
    }
    
    func addShape(_ shape: ColorShapeLayer) {
        self.selectedShapes.append(shape)
    }
    
    func removeShape(_ shape: ColorShapeLayer) {
        if let index = self.selectedShapes.index(of: shape) {
            self.selectedShapes.remove(at: index)
        }
    }
    
    func clearSelected() -> Void {
        for shape in self.selectedShapes {
            shape.deselect()
        }
        self.selectedShapes.removeAll()
    }
    
    // TODO: remove selectedShapes property and just use shapes?
    func getSelectedShapes() -> [ColorShapeLayer]? {
        return self.shapes.filter { $0.selected == true }
    }
    
    /**
     Apply color to all selected shapes
     
     :param: color
     */
    func applyColor(_ color: UIColor) {
        for shape in self.selectedShapes {
            shape.applyColor(color)
        }
    }
    
    func getData() -> [CAShapeLayer] {
        return self.shapes
    }
}
