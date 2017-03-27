//
//  SquareViewDelegate.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/17/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import Foundation

@objc protocol SquareViewDelegate: class {
    
    func squareDidLoad(shapes: [ColorShapeLayer])
    
    func selectShape(shape: ColorShapeLayer)
    
    @objc optional func squareWillSave(saveData: [String: Int])
    
    @objc optional func squareDidSave(success: Bool, filePath: String)

    /* Selected shapes have changed in any way: select/deselect1/toggle */
    @objc optional func selectDidChange()
}
