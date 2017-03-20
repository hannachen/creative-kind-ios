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
    var painting: Bool = false
    
    
    // MARK: Overrides
    
    override var isSelected: Bool {
        didSet {
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.colorSwatchButton.frame = CGRect(origin: CGPoint(x: self.frame.width/2 - CGFloat(colorButtonSize/2), y: self.frame.height/2 - CGFloat(colorButtonSize/2)), size: CGSize(width: colorButtonSize, height: colorButtonSize))
        self.colorSwatchButton.layer.cornerRadius = 0.5 * self.colorSwatchButton.bounds.size.width
        self.colorSwatchButton.isUserInteractionEnabled = false
    }

    
    func setupCellWith(_ color: UIColor) {
        self.color = color
        self.setupColorSwatchButton(color)
    }
    
    func setupColorSwatchButton(_ color: UIColor) {
        self.colorSwatchButton.paintMode = self.painting
        self.colorSwatchButton.backgroundColor = color
        self.colorSwatchButton.layer.borderColor = color.darkerColor(percent: 0.5).cgColor
        self.colorSwatchButton.imageView?.isHidden = !(self.isSelected && self.painting)
        self.colorSwatchButton.imageView?.tintColor = color.isLight() ? UIColor.darkGray : UIColor.white
    }
}
