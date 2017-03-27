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
    // Properties
    var shapes: [ColorShapeLayer] = []
    var delegate: SquareViewDelegate?
    var palette: [UIColor] = []
    
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
        guard let selectedShapes = self.selectedShapes(),
              let deleget = self.delegate else {
            return
        }
        for shape in selectedShapes {
            shape.deselect()
        }
        deleget.selectDidChange()
    }
    
    /**
     Apply color to all selected shapes
     
     :param: color
     */
    func applyColor(_ color: UIColor) -> Void {
        // Ignore if no shapes are selected
        guard let selectedShapes = self.selectedShapes() else {
            return
        }
        for shape in selectedShapes {
            shape.applyColor(color, index: self.getColorIndex(color))
        }
    }
    
    // Get the index of a color in the color set
    func getColorIndex(_ color: UIColor) -> Int {
        guard let index = self.palette.index(of: color) else {
            return 0
        }
        return index
    }
    
    func loadData(_ shapes: [ColorShapeLayer]) -> Void {
        self.shapes = shapes
    }
    
    func getData() -> [String: Int?] {
        var shapeData: [String: Int] = [:]
        for shape in self.shapes {
            guard let id = shape.id else {
                continue
            }
            shapeData[id] = shape.colorIndex
        }
        return shapeData
    }
    
    func convertData() -> [Int] {
        // Shape data
        var shapeData: [Int] = []
        for shape in self.shapes {
            guard let color = shape.color else {
                continue
            }
            shapeData.append(self.getColorIndex(color))
        }
        return shapeData
    }
}
