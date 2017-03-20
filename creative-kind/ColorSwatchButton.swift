//
//  ColorSwatchButton.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/19/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

private let swatchImagePadding: CGFloat = 5

class ColorSwatchButton: UIButton {
    // Properties
    var color: UIColor?
    var paintMode: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    // MARK: Overrides
    
    override var state: UIControlState {
        if paintMode {
            var options = ColorPaletteButtonControlState.paintMode
            options.insert(super.state)
            return options
        }
        return super.state
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.layer.borderWidth = 3
        self.clipsToBounds = true
        self.imageEdgeInsets = UIEdgeInsetsMake(swatchImagePadding,swatchImagePadding,swatchImagePadding,swatchImagePadding)
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        // Add a paintbrush to the button
        let image = #imageLiteral(resourceName: "paintbrush").withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: ColorPaletteButtonControlState.paintMode)
        
        // Remove image for normal state
        self.setImage(nil, for: .normal)
    }
}
