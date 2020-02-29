//
//  Alert.swift
//  PS2
//
//  Created by Calvin Chen on 26/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import UIKit

/**
The `Alert` class contains functions related to creating and presenting`UIAlert`
 in the `LevelDesignerController`, mostly related to saving/loading `GameLevel`s.
*/
class Alert {
    /// A cancel action that can be added to an `UIAlertController`
    static let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

    /// Presents an alert in an `UIViewController`.
    static func presentAlert(controller: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true)
    }

    /// Presents the UIAlert for overwriting an existing game level in a controller.
    static func presentOverwriteAlert(controller: LevelDesignerController, fileName: String) {
        let overwriteAlert = setupAlertController(title: "Level name already exists!",
                                                  message: "Overwrite saved level: \(fileName)?")

        overwriteAlert.addAction(UIAlertAction(title: "Overwrite", style: .default) { _ in
            handleSaveLevel(controller: controller, fileName: fileName)
        })
        overwriteAlert.addAction(cancelAction)
        controller.present(overwriteAlert, animated: true)
    }

    /// Presents the UIAlert for saving the current game level in a controller.
    static func presentSaveLevelAlert(controller: LevelDesignerController, message: String) {
        let saveAlert = setupAlertController(title: "Save", message: message)

        saveAlert.addTextField { $0.text = controller.currentLevelName }
        saveAlert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            guard let userInput = saveAlert.textFields?.first?.text else {
                presentAlert(controller: controller, title: "Error", message: "Textfield not found!")
                return
            }
            handleFileNameInputByUser(controller: controller, fileName: userInput)
        })
        saveAlert.addAction(cancelAction)
        controller.present(saveAlert, animated: true)
    }

//    /// Presents the UIAlert for loading previous game levels in a controller.
//    static func presentLoadLevelAlert(controller: LevelDesignerController, jsonFileNames: [String]) {
//        let loadAlert = setupAlertController(title: "Load", message: Settings.messageForLoadLevel)
//        guard !jsonFileNames.isEmpty else {
//            presentAlert(controller: controller, title: "Load Failed",
//    message: Settings.messageForLoadLevel_emptyLevels)
//            return
//        }
//        addLoadLevelOptionsToAlert(jsonFileNames: jsonFileNames, alert: loadAlert, controller: controller)
//        loadAlert.addAction(cancelAction)
//        controller.present(loadAlert, animated: true)
//    }

    /// Creates an `UIAlertController` for general use.
    private static func setupAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)

        return alertController
    }

    /// Saves the game level.
    /// If save fails, an alert is shown in controller.
    private static func handleSaveLevel(controller: LevelDesignerController, fileName: String) {
        guard FileStorageHelper.saveLevelToFile(gameLevel: controller.gameLevel, fileName: fileName) else {
            presentAlert(controller: controller, title: "Error", message: Settings.messageForSaveLevelFailure)
            return
        }

        guard let image = controller.getScreenshot() else {
            presentAlert(controller: controller, title: "Screenshot Failed", message: Settings.messageForScreenshotFail)
            return
        }

        let imageURL = FileStorageHelper.getFileURL(from: fileName, with: "png")
        guard (try? image.write(to: imageURL)) != nil else {
            presentAlert(controller: controller, title: "Screenshot Save Failed",
                         message: Settings.messageForScreenshotSaveFail)
            return
        }
    }

    /// Validates user input for game level saving.
    private static func handleFileNameInputByUser(controller: LevelDesignerController, fileName: String) {
        guard fileName.range(of: "[^a-zA-Z0-9]+", options: .regularExpression) == nil else {
            presentSaveLevelAlert(controller: controller, message: Settings.messageForSaveLevel_invalidFileName)
            return
        }

        if FileStorageHelper.checkIfFileExist(fileName: fileName) {
            presentOverwriteAlert(controller: controller, fileName: fileName)
        } else {
            handleSaveLevel(controller: controller, fileName: fileName)
        }
    }

    /// Creates Alert Actions for all the game level files.
    private static func addLoadLevelOptionsToAlert(
        jsonFileNames: [String], alert: UIAlertController, controller: LevelDesignerController) {
        for jsonFileName in jsonFileNames {
            let loadAction = createAlertActionForLoad(levelName: jsonFileName, controller: controller)
            alert.addAction(loadAction)
        }
    }

    /// Creates an Alert Action for a single game level.
    private static func createAlertActionForLoad(
        levelName: String, controller: LevelDesignerController) -> UIAlertAction {

        let loadActionForSingleGameLevel = UIAlertAction(title: levelName, style: .default) { _ in
            guard let gameLevelFromData = FileStorageHelper.loadDataFromFile(withName: levelName) else {
                presentAlert(controller: controller, title: "Error", message: Settings.messageForLoadLevelFailure)
                return
            }
            controller.loadNewLevel(level: gameLevelFromData, levelName: levelName)
        }
        return loadActionForSingleGameLevel
    }

    static func presentDeleteAlert(controller: LevelSelectionViewController, index: Int) {
        let deleteAlert = setupAlertController(title: "Delete Level",
                                               message: Settings.messageForDeleteLevel)

            let loadAction = UIAlertAction(title: "Delete", style: .default) { _ in
                controller.deleteLevel(at: index)
            }
            deleteAlert.addAction(loadAction)
            deleteAlert.addAction(cancelAction)
            controller.present(deleteAlert, animated: true)
    }
}
