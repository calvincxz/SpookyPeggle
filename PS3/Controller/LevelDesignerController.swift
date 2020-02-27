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
    @IBOutlet private weak var greenPegButton: PalettePegSelector!
    @IBOutlet private weak var background: UIImageView!
    // Not set to private due to usage in `LevelDesignerController` extension
    @IBOutlet weak var textDisplay: UILabel!
    @IBOutlet weak var pegBoardView: PegBoardView!

    var currentLevelName: String?
    var currentPegImageView: PegImageView?
    var currentSelectedPeg: Peg?
    var gameLevel: GameLevel!
    var pegToImageView: [Peg: PegImageView] = [:]

    override func viewDidLoad() {
        initializePegSelectors()
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard gameLevel == nil else {
            //print(gameLevel.getPegsInLevel().description)
            loadNewLevel(level: gameLevel, levelName: currentLevelName ?? "Untitled")
            return
        }
        gameLevel = GameLevel()

    }

    /// Initializes the peg type for all peg selectors.
    /// Blue peg selector is selected by default.
    private func initializePegSelectors() {
        orangePegButton.setButton(type: .orange, shape: .Circle)
        bluePegButton.setButton(type: .blue, shape: .Circle)
        greenPegButton.setButton(type: .green, shape: .Circle)
        PalettePegSelector.currentSelected = bluePegButton
        bluePegButton.selectButton()
    }

    /// Resets the level design when the reset button is pressed.
    @IBAction private func resetLevel(_ sender: UIButton) {
        resetLevel()
        textDisplay.text = "Reset Level Success"
    }

    @IBAction private func switchPaletteButtons(_ sender: UIButton) {
        orangePegButton.togglePegShape()
        bluePegButton.togglePegShape()
        greenPegButton.togglePegShape()
        if let current = PalettePegSelector.currentSelected {
            PalettePegSelector.currentSelected = current
        }
    }

    /// Resets all data in the current game level.
    private func resetLevel() {
        pegBoardView.clearBoard()
        gameLevel.resetLevel()
        pegToImageView = [:]
    }

    /// Replaces level with data from another `GameLevel`
    func loadNewLevel(level: GameLevel, levelName: String) {
        let newLevel = GameLevel()
        newLevel.loadGameLevel(gameLevel: level)
        resetLevel()
        currentLevelName = levelName
        print(newLevel.getPegsInLevel().description)
        for peg in newLevel.getPegsInLevel() {
            gameLevel?.addToLevel(addedPeg: peg)
            let pegImageView = PegImageView(peg: peg)
            pegBoardView.addPegToBoard(peg: pegImageView)
            pegToImageView[peg] = pegImageView

        }
        textDisplay.text = "Load Level Success"
    }

    @IBAction private func startGame(_ sender: UIButton) {
        performSegue(withIdentifier: "levelDesignToPlay", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GamePlayController {
            let target = segue.destination as? GamePlayController
            target?.gameLevel = gameLevel
        }
        if segue.destination is LevelSelectionViewController {
            let target = segue.destination as? LevelSelectionViewController
            target?.previousScreen = .LevelDesign
        }
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
        performSegue(withIdentifier: "levelDesignToLevelSelect", sender: self)
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

    func getScreenshot() -> Data? {
        UIGraphicsBeginImageContext(pegBoardView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        background.layer.render(in: context)
        pegBoardView.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return image.pngData()
    }
}
