//
//  LevelDesignerController.swift
//  SpookyPeggle
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
    @IBOutlet private weak var purplePegButton: PalettePegSelector!
    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var pegBoardView: PegBoardView!

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
            loadNewLevel(level: gameLevel, levelName: currentLevelName ?? "Untitled")
            return
        }
        gameLevel = GameLevel()
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

    /// Initializes the peg type for all peg selectors.
    /// Blue peg selector is selected by default.
    private func initializePegSelectors() {
        bluePegButton.setButton(type: .blue, shape: .Circle)
        orangePegButton.setButton(type: .orange, shape: .Circle)
        greenPegButton.setButton(type: .green, shape: .Circle)
        purplePegButton.setButton(type: .purple, shape: .Circle)

        PalettePegSelector.currentSelected = bluePegButton
        bluePegButton.selectButton()
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
        for peg in newLevel.getPegsInLevel() {
            gameLevel?.addToLevel(addedPeg: peg)
            let pegImageView = PegImageView(peg: peg)
            pegBoardView.addPegToBoard(peg: pegImageView)
            pegToImageView[peg] = pegImageView

        }
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
/// Extension for Buttons Actions
extension LevelDesignerController {

    /// Resets the level design when the reset button is pressed.
    @IBAction private func resetLevel(_ sender: UIButton) {
        resetLevel()
    }

    @IBAction private func switchPaletteButtons(_ sender: UIButton) {
        orangePegButton.togglePegShape()
        bluePegButton.togglePegShape()
        greenPegButton.togglePegShape()
        purplePegButton.togglePegShape()
        if let current = PalettePegSelector.currentSelected {
            PalettePegSelector.currentSelected = current
        }
    }

    /// Starts a game
    @IBAction private func startGame(_ sender: UIButton) {
        performSegue(withIdentifier: "levelDesignToPlay", sender: self)

    }

    /// Returns to main menu when menu button is pressed
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
        if let previousPegSelector = PalettePegSelector.currentSelected {
            previousPegSelector.unselectButton()
        }

        PalettePegSelector.currentSelected = sender
        sender.selectButton()
    }
}

/**
Extension for `LevelDesignerController`, which supports all the required gestures.
*/
extension LevelDesignerController {
    @IBAction private func handleRotate(_ sender: UIRotationGestureRecognizer) {
        guard let pegView = currentPegImageView, let oldPeg = currentSelectedPeg else {
            return
        }

        let rotation = sender.rotation
        let rotatedPeg = oldPeg.rotate(by: rotation)
        gameLevel.removeFromLevel(removedPeg: oldPeg)

        if gameLevel.canInsertPeg(peg: rotatedPeg) {
            currentSelectedPeg = rotatedPeg
            gameLevel.addToLevel(addedPeg: rotatedPeg)
            pegView.rotate(by: rotation)
            currentPegImageView = pegView
            pegToImageView[oldPeg] = nil
            pegToImageView[rotatedPeg] = pegView

        } else {
            gameLevel.addToLevel(addedPeg: oldPeg)
            pegToImageView[oldPeg] = pegView
        }
        sender.rotation = 0

    }

    /// Resizes the peg when pinch gesture is detected
    @IBAction private func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        guard let pegView = currentPegImageView, let oldPeg = currentSelectedPeg else {
            return
        }

        let scale = sender.scale
        let resizedPeg = oldPeg.resize(by: scale)
        gameLevel.removeFromLevel(removedPeg: oldPeg)

        if gameLevel.canInsertPeg(peg: resizedPeg) &&
            resizedPeg.isSizeWithinLimit() {
            currentSelectedPeg = resizedPeg
            gameLevel.addToLevel(addedPeg: resizedPeg)
            pegView.resize(by: scale)
            currentPegImageView = pegView
            pegToImageView[oldPeg] = nil
            pegToImageView[resizedPeg] = pegView

        } else {
            gameLevel.addToLevel(addedPeg: oldPeg)
            pegToImageView[oldPeg] = pegView
        }
        sender.scale = 1.0

    }

    /// Updates the peg when single tap is detected on the `PegBoardView`.
    @IBAction private func handleSingleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            handleUpdatePeg(sender)
        }
    }

    /// Deletes the peg when long press is detected on a specific `PegImageView`.
    @IBAction private func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
            handleDeletePeg(sender)
    }

    /// Drags the peg when pan gesture is detected on a specific `PegImageView`.
    @IBAction private func handleDrag(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            handleDragStart(sender)

        } else if sender.state == .changed {
            handleDragging(sender)

        } else if sender.state == .ended {
            handleDragEnd(sender)
        }
    }

    /// Deletes a peg from game level.
    private func handleDeletePeg(_ sender: UIGestureRecognizer) {
        let location = sender.location(in: pegBoardView)
        if let pegToRemove = gameLevel.findPeg(at: location) {
            removePegFromModelView(peg: pegToRemove)
        }
    }

    /// Updates a peg in game level.
    private func handleUpdatePeg(_ sender: UIGestureRecognizer) {
        guard let selectedPegType = PalettePegSelector.currentSelected?.pegType,
            let selectedPegShape = PalettePegSelector.currentSelected?.pegShape else {
            handleDeletePeg(sender)
            return
        }

        // Creates new peg at current location
        let location = sender.location(in: pegBoardView)
        let newlyCreatedPeg = Peg(type: selectedPegType, centre: location, shape: selectedPegShape)

        guard gameLevel.canInsertPeg(peg: newlyCreatedPeg) else {
            if let existingPeg = gameLevel.findPeg(at: location) {
                currentSelectedPeg = existingPeg
                currentPegImageView?.applyUnselectedEffect()
                currentPegImageView = pegToImageView[existingPeg]
                currentPegImageView?.applySelectedEffect()
            }
            return
        }
        addPegToModelView(peg: newlyCreatedPeg)
    }

    /// Finds peg at location when drag begins.
    private func handleDragStart(_ sender: UIPanGestureRecognizer) {
        currentPegImageView?.applyUnselectedEffect()

        let location = sender.location(in: pegBoardView)
        if let peg = gameLevel.findPeg(at: location) {
            currentSelectedPeg = peg
            currentPegImageView = pegToImageView[peg]
            currentPegImageView?.applySelectedEffect()
            gameLevel.removeFromLevel(removedPeg: peg)
            pegToImageView[peg] = nil
        } else {
            currentSelectedPeg = nil
            currentPegImageView = nil
        }
    }

    /// Moves the selected peg along with input gesture only if it is within the bounds of the board.
    private func handleDragging(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: pegBoardView)
        if self.pegBoardView.bounds.contains(location) {
            currentPegImageView?.center = location
        }
    }

    /// Checks if final location when drag ends is valid and registers its final location.
    private func handleDragEnd(_ sender: UIPanGestureRecognizer) {
        guard let pegImageView = currentPegImageView, let oldPeg = currentSelectedPeg else {
            return
        }
        let oldLocation = oldPeg.centre
        let newLocation = sender.location(in: pegBoardView)
        let newlySelectedPeg = oldPeg.moveTo(location: newLocation)

        if gameLevel.canInsertPeg(peg: newlySelectedPeg) && pegBoardView.bounds.contains(newLocation) {
            pegImageView.moveTo(point: newLocation)
            reAddPegToModel(peg: newlySelectedPeg, pegImageView: pegImageView)
        } else {
            pegImageView.moveTo(point: oldLocation)
            reAddPegToModel(peg: oldPeg, pegImageView: pegImageView)
        }
    }

    /// Re-adds peg to model after drag gesture ends.
    private func reAddPegToModel(peg: Peg, pegImageView: PegImageView) {
        gameLevel.addToLevel(addedPeg: peg)
        pegToImageView[peg] = pegImageView
    }

    /// Adds a peg to both the model and view.
    private func addPegToModelView(peg: Peg) {
        let pegImageView = PegImageView(peg: peg)

        pegToImageView[peg] = pegImageView
        gameLevel.addToLevel(addedPeg: peg)
        pegBoardView.addPegToBoard(peg: pegImageView)
    }

    /// Removes a peg from both the model and view.
    private func removePegFromModelView(peg: Peg) {
        guard let pegImageView = pegToImageView[peg] else {
            return
        }
        gameLevel.removeFromLevel(removedPeg: peg)
        pegBoardView.removePegFromBoard(peg: pegImageView)
        pegToImageView[peg] = nil
    }
}

extension LevelDesignerController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
            -> Bool {

       if gestureRecognizer is UIRotationGestureRecognizer &&
              otherGestureRecognizer is UIPinchGestureRecognizer {
          return true
       }

       return false
    }
}
