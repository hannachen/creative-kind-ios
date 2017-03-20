//
//  ColorPaletteButtonControlState.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/19/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

/**
 *  Custom control state for color palette buttons
 */
public struct ColorPaletteButtonControlState {
    /// Indicates paint mode
    public static let paintMode: UIControlState = UIControlState(rawValue: 1 << 16)
}
