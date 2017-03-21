//
//  SquareViewDelegate.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/17/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import Foundation

protocol SquareViewDelegate {
    
    func squareDidLoad(shapes: [ColorShapeLayer])
    
    func selectShape(shape: ColorShapeLayer)

    func selectDidChange()
}
