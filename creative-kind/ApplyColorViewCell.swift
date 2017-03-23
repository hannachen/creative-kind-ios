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
    
    // MARK: Overrides
    
    // TODO: Remove below if unused
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.applyColorButton.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.frame.width, height: self.frame.height))
    }
    
    
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
    
    
    /*
     Add and style checkmark image, attach events
     */
    func setupButton() {
        self.applyColorButton.paintMode = self.painting
    }
}
