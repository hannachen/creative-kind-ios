//
//  ApplyColorViewCell.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/19/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

class ApplyColorViewCell: UICollectionReusableView {
    // Outlets
    @IBOutlet var applyColorButton: ApplyColorButton!
    
    // Properties
    var painting: Bool = false
    var delegate: ColorPaletteViewCellDelegate?
    
    
    // MARK: ApplyColorViewCellDelegate
    
    // TODO: Remove below if unused
    func singleTapButton() {
        guard let delegate = self.delegate else {
            return
        }
        delegate.singleTapApplyColorButton()
    }
    
    func tripleTapButton() {
        guard let delegate = self.delegate else {
            return
        }
        delegate.tripleTapApplyColorButton()
    }
    
    
    func setupCell() {
        self.applyColorButton.paintMode = self.painting
    }
}
