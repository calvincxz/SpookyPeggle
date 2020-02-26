//
//  PalettePegSelector.swift
//  PS2
//
//  Created by Calvin Chen on 22/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

/**
`PalettePegSelector` is a class which represents the
 peg selector buttons in the palette.
 It has been initialized in the Interface Builder.
*/
class PalettePegSelector: UIButton {

    static var currentSelected: PalettePegSelector?
    var pegType: PegType? {
        didSet {
            guard let type = pegType, let shape = pegShape else {
                return
            }
            setImage(GameDisplayHelper.getPegImage(of: type, shape: shape), for: .normal)
        }
    }
    var pegShape: PegShape? {
        didSet {
            guard let type = pegType, let shape = pegShape else {
                return
            }
            setImage(GameDisplayHelper.getPegImage(of: type, shape: shape), for: .normal)
        }
    }

    func setButton(type: PegType, shape: PegShape) {
        self.pegType = type
        self.pegShape = shape
    }

    func togglePegShape() {
        guard let shape = pegShape else {
            return
        }
        switch shape {
        case .Circle:
            pegShape = .Triangle
        case .Triangle:
            pegShape = .Circle
        }
    }

    /// Changes appearance of button when selected
    func selectButton() {
        alpha = Settings.darkAlphaForSelectedButton
    }

    /// Changes appearance of button when unselected
    func unselectButton() {
        alpha = Settings.lowAlphaForUnselectedButton
    }

}
