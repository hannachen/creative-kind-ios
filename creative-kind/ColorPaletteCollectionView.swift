//
//  ColorPaletteCollectionView.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/19/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

class ColorPaletteCollectionView: UICollectionView {
    // Properties
    var paintMode: Bool = false
    var paintModeColor: UIColor?
    
    func paintMode(_ paint: Bool = false) {
        self.paintMode = paint
    }
    
    func paintColor(_ color: UIColor) {
        self.paintModeColor = color
    }

    func togglePaintMode() -> Bool {
        if self.paintMode {
            self.paintModeColor = nil
        }
        self.paintMode = !self.paintMode
        return self.paintMode
    }
}
