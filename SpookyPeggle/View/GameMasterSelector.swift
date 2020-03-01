//
//  GameMasterSelector.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 27/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

class GameMasterSelector: UIButton {

    static var currentSelected: GameMasterSelector?

    private var master: GameMaster? {
        didSet {
            Settings.gameMaster = master
        }
    }

    func setupButton(master: GameMaster) {
        backgroundColor = .gray
        self.master = master
        layer.cornerRadius = 0.5 * bounds.size.width
        clipsToBounds = true
    }

    /// Changes appearance of button when selected
    func selectButton() {
        Settings.gameMaster = master
        backgroundColor = .yellow
        alpha = Settings.darkAlphaForSelectedButton

    }

    /// Changes appearance of button when unselected
    func unselectButton() {
        backgroundColor = .gray
        alpha = 0.7
    }

}
