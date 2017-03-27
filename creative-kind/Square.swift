//
//  Square.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/20/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Square: NSObject, NSCoding {
    // Properties
    struct PropertyKey {
        static let data = "square"
    }
    var shapeData: [String: Int?] = [:]
    var shapes: [ColorShapeLayer] = []
    var delegate: SquareViewDelegate?
    var palette: [UIColor] = []
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent(PropertyKey.data)
    
    
    init(shapes: [ColorShapeLayer]) {
        self.shapes = shapes
    }
    
    // MARK: NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        if let shapeData = aDecoder.decodeObject(forKey: PropertyKey.data) as? [String: Int] {
            self.shapeData = shapeData
        }
        return nil
    }
    
    func encode(with aCoder: NSCoder) -> Void {
        let shapeData = self.getData()
        aCoder.encode(shapeData, forKey: PropertyKey.data)
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
        deleget.selectDidChange?()
    }
    
    func setupShapes(_ shapes: [ColorShapeLayer]) {
        self.shapes = shapes
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
    
    func getData() -> [String: Int] {
        var shapeData: [String: Int] = [:]
        for shape in self.shapes {
            guard let id = shape.id,
                  let colorIndex = shape.colorIndex else {
                continue
            }
            // Only save coloured shapes
            shapeData[id] = colorIndex
        }
        return shapeData
    }
    
    func save() {
        let saveData = self.getData()
        if let delegate = self.delegate {
            delegate.squareWillSave?(saveData: saveData)
        }
        self.saveData(saveData)
    }
    
    func saveData(_ shapeData: [String: Int]) -> Void {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(shapeData, toFile: Square.ArchiveURL.path)
        if let delegate = self.delegate {
            delegate.squareDidSave?(success: isSuccessfulSave, filePath: Square.ArchiveURL.path)
        }
    }
    
    func loadData() -> Void {
        guard let shapeData = NSKeyedUnarchiver.unarchiveObject(withFile: Square.ArchiveURL.path) as? [String: Int] else {
            return
        }
        self.shapeData = shapeData
        print("shape data: \(self.shapeData)")
        for shape in self.shapes {
            guard let id = shape.id,
                  let colorIndex = shapeData[id],
                  let color = self.palette[colorIndex] as UIColor? else {
                continue
            }
            shape.select()
            shape.applyColor(color, index: colorIndex)
            shape.deselect()
        }
    }
}
