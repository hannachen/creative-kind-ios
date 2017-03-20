//
//  ApplyColorButton.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/19/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

private let buttonImagePadding: CGFloat = 10

class ApplyColorButton: UIButton {
    // Properties
    var paintMode: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    // MARK: Overrides
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.imageEdgeInsets = UIEdgeInsetsMake(buttonImagePadding,buttonImagePadding,buttonImagePadding,buttonImagePadding)
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.imageView?.tintColor = UIColor.gray
        
        // Add a checkmark to the button
        let checkmark = #imageLiteral(resourceName: "checkmark").withRenderingMode(.alwaysTemplate)
        self.setImage(checkmark, for: .normal)
        
        // Add paintbucket image to the button
        let paintImage = #imageLiteral(resourceName: "paintbucket").withRenderingMode(.alwaysTemplate)
        self.setImage(paintImage, for: ColorPaletteButtonControlState.paintMode)
    }
    
    override var state: UIControlState {
        if paintMode {
            var options = ColorPaletteButtonControlState.paintMode
            options.insert(super.state)
            return options
        }
        return super.state
    }

}
