//
//  EndGameViewController.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 29/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    var isGameWon: Bool?
    var previousGameLevel: GameLevel?

    @IBOutlet private weak var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMessage()
    }

    func setGameState(state: Bool) {
        isGameWon = state
    }

    private func initializeMessage() {
        guard let win = isGameWon else {
            return
        }
        if win {
            MusicPlayer.playGameWinMusic()
            textLabel.text = "victory"
        } else {
            MusicPlayer.playGameLoseMusic()
            textLabel.text = "Defeat"
        }
    }

    @IBAction private func replayLevel(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }

    @IBAction private func backToMainMenu(_ sender: UIButton) {
        performSegue(withIdentifier: "endToMenu", sender: self)
    }
}
