//
//  LevelDesignerController + Gestures.swift
//  PS2
//
//  Created by Calvin Chen on 22/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

/**
 Extension for `LevelDesignerController`, which supports all the required gestures.
 */
extension LevelDesignerController {

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
        guard let selectedPegType = PalettePegSelector.currentSelected?.pegType else {
            return
        }
        // Handles peg deletion
        guard selectedPegType != PegType.erase else {
            handleDeletePeg(sender)
            return
        }
        // Creates new peg at current location
        let location = sender.location(in: pegBoardView)
        var newlyCreatedPeg: Peg
        if selectedPegType == .green {
            newlyCreatedPeg = Peg(type: selectedPegType, triangleOfCentre: location)
        } else {
            newlyCreatedPeg = Peg(type: selectedPegType, circleOfCentre: location)
        }

        guard gameLevel.canInsertPeg(peg: newlyCreatedPeg) else {
            return
        }
        addPegToModelView(peg: newlyCreatedPeg)
    }

    /// Finds peg at location when drag begins.
    private func handleDragStart(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: pegBoardView)
        if let peg = gameLevel.findPeg(at: location) {
            currentSelectedPeg = peg
            currentPegImageView = pegToImageView[peg]
            gameLevel.removeFromLevel(removedPeg: peg)
            pegToImageView[peg] = nil
            textDisplay.text = "found"
        } else {
            textDisplay.text = "nope"
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
        var newlySelectedPeg: Peg
        if oldPeg.pegType == .green {
            newlySelectedPeg = Peg(type: oldPeg.pegType, triangleOfCentre: newLocation)
        } else {
            newlySelectedPeg = Peg(type: oldPeg.pegType, circleOfCentre: newLocation)
        }

        if gameLevel.canInsertPeg(peg: newlySelectedPeg) && self.pegBoardView.bounds.contains(newLocation) {
            pegImageView.moveTo(point: newLocation)
            reAddPegToModel(peg: newlySelectedPeg, pegImageView: pegImageView)
        } else {
            pegImageView.moveTo(point: oldLocation)
            reAddPegToModel(peg: oldPeg, pegImageView: pegImageView)
        }
        //reAddPegToModel(peg: newlySelectedPeg, pegImageView: pegImageView)
    }

    /// Re-adds peg to model after drag gesture ends.
    private func reAddPegToModel(peg: Peg, pegImageView: PegImageView) {
        gameLevel.addToLevel(addedPeg: peg)
        pegToImageView[peg] = pegImageView
        currentPegImageView = nil
        currentSelectedPeg = nil
        textDisplay.text = "Drag Success"
    }

    /// Adds a peg to both the model and view.
    private func addPegToModelView(peg: Peg) {
        let pegImageView = PegImageView(peg: peg)

        pegToImageView[peg] = pegImageView
        gameLevel.addToLevel(addedPeg: peg)
        pegBoardView.addPegToBoard(peg: pegImageView)
        textDisplay.text = "Add Success"
    }

    /// Removes a peg from both the model and view.
    private func removePegFromModelView(peg: Peg) {
        guard let pegImageView = pegToImageView[peg] else {
            return
        }
        gameLevel.removeFromLevel(removedPeg: peg)
        pegBoardView.removePegFromBoard(peg: pegImageView)
        pegToImageView[peg] = nil
        textDisplay.text = "Delete Success"
    }
}
