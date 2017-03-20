//
//  ApplyColorViewCell
//  creative-kind
//
//  Created by Hanna Chen on 3/19/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

class ApplyColorViewCell: UICollectionViewCell {
    // Outlets
    @IBOutlet var applyColorButton: ApplyColorButton!
    
    // Properties
    var painting: Bool = false
    var delegate: ColorPaletteViewCellDelegate?
    
    
    // MARK: Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.applyColorButton.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.frame.width, height: self.frame.height))
    }
    
    
    // MARK: ApplyColorViewCellDelegate
    
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
        self.setupApplyColorButton()
    }
    
    /*
     Add and style checkmark image, attach events
     */
    func setupApplyColorButton() {
        
        self.applyColorButton.paintMode = self.painting
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapButton))
        let tripleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tripleTapButton))
        
        singleTap.numberOfTapsRequired = 1
        tripleTap.numberOfTapsRequired = 3
        
        self.applyColorButton.addGestureRecognizer(singleTap)
        self.applyColorButton.addGestureRecognizer(tripleTap)
    }
}
