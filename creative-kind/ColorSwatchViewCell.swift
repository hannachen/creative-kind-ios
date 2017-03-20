//
//  ColorSwatchViewCell.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/17/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

private let colorButtonSize: CGFloat = 40

class ColorSwatchViewCell: UICollectionViewCell {
    // Outlets
    @IBOutlet var colorSwatchButton: ColorSwatchButton!
    
    // Properties
    var color: UIColor?
    var delegate: ColorPaletteViewCellDelegate?
    var painting: Bool = false
    var selectedSwatch: Bool = false
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.colorSwatchButton.frame = CGRect(origin: CGPoint(x: self.frame.width/2 - CGFloat(colorButtonSize/2), y: self.frame.height/2 - CGFloat(colorButtonSize/2)), size: CGSize(width: colorButtonSize, height: colorButtonSize))
        self.colorSwatchButton.layer.cornerRadius = 0.5 * self.colorSwatchButton.bounds.size.width
    }
    
    // MARK: ApplyColorViewCellDelegate

    func touchColorButton(_ sender: ColorSwatchButton) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.clickColorButton(self)
    }

    
    func setupCellWith(_ color: UIColor) {
        self.color = color
        self.setupColorSwatchButton(color)
        print("paint mode? \(self.painting)")
    }
    
    func setupColorSwatchButton(_ color: UIColor) {
        self.colorSwatchButton.paintMode = self.painting
        self.colorSwatchButton.backgroundColor = color
        self.colorSwatchButton.layer.borderColor = color.darkerColor(percent: 0.5).cgColor
        self.colorSwatchButton.addTarget(self, action: #selector(touchColorButton), for: UIControlEvents.touchDown)
        self.colorSwatchButton.imageView?.isHidden = !(self.selectedSwatch && self.painting)
        
        print("selected? \(self.selectedSwatch)")
        print("should hide icon? \(!self.selectedSwatch)")
    }
}
