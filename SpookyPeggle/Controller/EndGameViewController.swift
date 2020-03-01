//
//  EndGameViewController.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 29/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var endGameMessage: UILabel!

    private var scoreText: String = ""
    private var isGameWon: Bool?

    /// Hides the status bar at the top
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMessage()
    }

    func setGameState(state: Bool, score: String) {
        self.isGameWon = state
        self.scoreText = score
    }

    private func initializeMessage() {
        guard let win = isGameWon else {
            return
        }
        if win {
            MusicPlayer.playGameWinMusic()
            endGameMessage.text = "victory"
        } else {
            MusicPlayer.playGameLoseMusic()
            endGameMessage.text = "Defeat"
        }
        scoreLabel.text = scoreText
    }

    @IBAction private func replayLevel(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }

    @IBAction private func backToMainMenu(_ sender: UIButton) {
        performSegue(withIdentifier: "endToMenu", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GamePlayController {
            let target = segue.destination as? GamePlayController
            target?.viewDidLoad()
        }
    }
}
