//
//  HomeViewController.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 20/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var batButton: GameMasterSelector!
    @IBOutlet private weak var pumpkinButton: GameMasterSelector!
    @IBOutlet private weak var wizardButton: GameMasterSelector!

    /// Hides the status bar at the top
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        initializeGameMasterSelectors()
        MusicPlayer.playBackgroundMusic()
        super.viewDidLoad()
    }

    private func initializeGameMasterSelectors() {
        batButton.setupButton(master: .Bat)
        pumpkinButton.setupButton(master: .Pumpkin)
        wizardButton.setupButton(master: .FlameWizard)
        GameMasterSelector.currentSelected = pumpkinButton
        pumpkinButton.selectButton()
    }

    @IBAction private func goToLevelDesign(_ sender: UIButton) {
        performSegue(withIdentifier: "homeToLevelDesign", sender: self)
    }

    @IBAction private func goToSelect(_ sender: UIButton) {
        performSegue(withIdentifier: "select", sender: self)
    }

    @IBAction private func chooseMaster(_ sender: GameMasterSelector) {
        if let previous = GameMasterSelector.currentSelected {
            previous.unselectButton()
        }

        GameMasterSelector.currentSelected = sender
        sender.selectButton()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LevelSelectionViewController {
            let target = segue.destination as? LevelSelectionViewController
            target?.previousScreen = .Home
        }
    }
}
