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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.colorSwatchButton.frame = CGRect(origin: CGPoint(x: self.frame.width/2 - CGFloat(colorButtonSize/2), y: self.frame.height/2 - CGFloat(colorButtonSize/2)), size: CGSize(width: colorButtonSize, height: colorButtonSize))
        self.colorSwatchButton.layer.cornerRadius = 0.5 * self.colorSwatchButton.bounds.size.width
    }
    
    func setupCellWith(_ color: UIColor) {
        self.color = color
        self.setupColorSwatchButton(color)
    }
    
    func setupColorSwatchButton(_ color: UIColor) {
        self.colorSwatchButton.layer.borderColor = color.darkerColor(percent: 0.5).cgColor
        self.colorSwatchButton.layer.borderWidth = 3
        self.colorSwatchButton.clipsToBounds = true
        self.colorSwatchButton.backgroundColor = color
        self.colorSwatchButton.addTarget(self, action: #selector(touchColorButton), for: UIControlEvents.touchDown)
    }
    
    
    // MARK: ApplyColorViewCellDelegate

    func touchColorButton(_ sender: ColorSwatchButton) {
        guard let delegate = self.delegate,
              let color = self.color else {
            return
        }
        delegate.clickColorButton(color)
    }
}
