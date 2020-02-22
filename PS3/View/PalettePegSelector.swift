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
    var pegType: PegType?

    /// Changes appearance of button when selected
    func selectButton() {
        alpha = Settings.darkAlphaForSelectedButton
    }

    /// Changes appearance of button when unselected
    func unselectButton() {
        alpha = Settings.lowAlphaForUnselectedButton
    }

}
