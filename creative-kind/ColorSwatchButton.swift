//
//  ColorSwatchButton.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/19/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

class ColorSwatchButton: UIButton {
    
    var color: UIColor?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.layer.borderWidth = 3
        self.clipsToBounds = true
        self.backgroundColor = color
    }
    
    // MARK: Overrides
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layoutColorSwatch()
    }
    
    
    private func layoutColorSwatch() {
        if let color = self.color {
            self.layer.borderColor = color.darkerColor(percent: 0.5).cgColor
        }
    }
}
