//
//  GameMasterSelector.swift
//  PS3
//
//  Created by Calvin Chen on 27/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

class GameMasterSelector: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    static var currentSelected: GameMasterSelector?

    var master: GameMaster? {
        didSet {
            Settings.gameMaster = master
        }
    }

    func setupButton(master: GameMaster) {
        backgroundColor = .gray
        self.master = master
        layer.cornerRadius = 0.5 * bounds.size.width
        clipsToBounds = true
//        let image = GameDisplayHelper.getGameMasterImage(master: master)
//        setImage(image, for: .normal)
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
