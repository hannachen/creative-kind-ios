//
//  ApplyColorViewCell
//  creative-kind
//
//  Created by Hanna Chen on 3/19/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

private let buttonImagePadding: CGFloat = 10

class ApplyColorViewCell: UICollectionViewCell {
    // Outlets
    @IBOutlet var applyColorButton: UIButton!
    
    // Properties
    var delegate: ColorPaletteViewCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.applyColorButton.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.frame.width, height: self.frame.height))
    }
    
    func setupCell() {
        self.setupApplyColorButton()
    }
    
    /*
     Add and style checkmark image, attach events
     */
    func setupApplyColorButton() {
        // Add a checkmark to the button
        let image = #imageLiteral(resourceName: "checkmark").withRenderingMode(.alwaysTemplate)
        self.applyColorButton.setImage(image, for: .normal)
        self.applyColorButton.imageEdgeInsets = UIEdgeInsetsMake(buttonImagePadding,buttonImagePadding,buttonImagePadding,buttonImagePadding)
        self.applyColorButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.applyColorButton.imageView?.tintColor = UIColor.gray
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapButton))
        let tripleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tripleTapButton))
        
        singleTap.numberOfTapsRequired = 1
        tripleTap.numberOfTapsRequired = 3
        
        self.applyColorButton.addGestureRecognizer(singleTap)
        self.applyColorButton.addGestureRecognizer(tripleTap)
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
}
