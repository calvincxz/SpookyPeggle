//
//  LevelDesignerController.swift
//  PeggleGame
//
//  Created by Calvin Chen on 21/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

class LevelDesignerController: UIViewController {
    @IBOutlet private weak var orangePegButton: PalettePegSelector!
    @IBOutlet private weak var erasePegButton: PalettePegSelector!
    @IBOutlet private weak var bluePegButton: PalettePegSelector!
    @IBOutlet private weak var background: UIImageView!
    // Not set to private due to usage in `LevelDesignerController` extension
    @IBOutlet weak var textDisplay: UILabel!
    @IBOutlet weak var pegBoardView: PegBoardView!

    @IBOutlet weak var greenPegButton: PalettePegSelector!
    var currentLevelName = "Untitled"
    var currentPegImageView: PegImageView?
    var currentSelectedPeg: Peg?
    var gameLevel = GameLevel()
    var pegToImageView: [Peg: PegImageView] = [:]

    override func viewDidLoad() {
        initializePegSelectors()
        print(pegBoardView.bounds.debugDescription)
        super.viewDidLoad()
    }

    /// Initializes the peg type for all peg selectors.
    /// Blue peg selector is selected by default.
    private func initializePegSelectors() {
        orangePegButton.pegType = PegType.orange
        bluePegButton.pegType = PegType.blue
        greenPegButton.pegType = PegType.green
        erasePegButton.pegType = PegType.erase
        PalettePegSelector.currentSelected = bluePegButton
        bluePegButton.alpha = 1
    }

    /// Resets the level design when the reset button is pressed.
    @IBAction private func resetLevel(_ sender: UIButton) {
        resetLevel()
        textDisplay.text = "Reset Level Success"
    }

    /// Resets all data in the current game level.
    private func resetLevel() {
        pegBoardView.clearBoard()
        gameLevel.resetLevel()
        pegToImageView = [:]
    }

    /// Replaces level with data from another `GameLevel`
    func loadNewLevel(newLevel: GameLevel, levelName: String) {

        resetLevel()
        currentLevelName = levelName
        for peg in newLevel.getPegsInLevel() {
            gameLevel.addToLevel(addedPeg: peg)
            let pegImageView = PegImageView(peg: peg)
            pegBoardView.addPegToBoard(peg: pegImageView)
            pegToImageView[peg] = pegImageView

        }
        textDisplay.text = "Load Level Success"
    }

    @IBAction private func startGame(_ sender: UIButton) {
        performSegue(withIdentifier: "levelDesignToPlay", sender: self)
    }

    /// Saves the level design when the save button is pressed.
    @IBAction private func returnToMenu(_ sender: UIButton) {
        performSegue(withIdentifier: "levelDesignToHome", sender: self)
    }

    /// Saves the level design when the save button is pressed.
    @IBAction private func saveLevel(_ sender: UIButton) {
        Alert.presentSaveLevelAlert(controller: self, message: Settings.messageForSaveLevel)
    }

    /// Loads previously saved level designs when the load button is pressed.
    @IBAction private func loadLevel(_ sender: UIButton) {
        guard let jsonFileNames = FileStorageHelper.getDocumentDirectoryFileNames() else {
            Alert.presentAlert(controller: self, title: "Error", message: Settings.messageForDocumentDirectoryAccessFailure)
            return
        }

        Alert.presentLoadLevelAlert(controller: self, jsonFileNames: jsonFileNames)
    }

    /// Selects the new button when the peg selector button is pressed.
    @IBAction private func changePegSelector(_ sender: PalettePegSelector) {
        textDisplay.text = "Changed Peg Selector"
        if let previousPegSelector = PalettePegSelector.currentSelected {
            previousPegSelector.unselectButton()
        }

        PalettePegSelector.currentSelected = sender
        sender.selectButton()
    }

}
