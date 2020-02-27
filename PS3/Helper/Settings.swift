//
//  Settings.swift
//  PeggleGame
//
//  Created by Calvin Chen on 30/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//
import CoreGraphics

/**
The `Settings` class contains constants for the game.
*/
enum Settings {
    // Constants
    static let defaultPegDiameter = CGFloat(60)
    static let defaultTrianglePegLength = CGFloat(60)
    static let defaultBallDiameter = CGFloat(40)
    static let lowAlphaForUnselectedButton = CGFloat(0.5)
    static let darkAlphaForSelectedButton = CGFloat(1)
    static let initialVelocityForBall = CGFloat(5)
    static let initialVelocityForBucket = CGVector(dx: 3, dy: 0)
    static let accelerationForBall = CGVector(dx: 0, dy: 0.2)
    static let safetyTolerance = CGFloat(5)
    static let energyLoss = CGFloat(0.8)
    static let initialBallCount = 5
    static let cannonRotationPerGesture = CGFloat(0.02)
    static let maximumCannonRotationAngle = CGFloat(1.2)
    static let bucketWidth = CGFloat(220)
    static let bucketHeight = CGFloat(60)
    static let maxVelocityForBall = CGFloat(10)
    static let preloadedLevelNames = ["level1.json", "level2.json", "level3.json",
                                      "level1.png", "level2.png", "level3.png"]

    // User-defined variables
    static var gameMaster: GameMaster? = .Pumpkin

    // Messages
    static let messageForSaveLevel = "Enter level name: "
    static let messageForLoadLevel = "Choose level to load: "
    static let messageForSaveLevel_invalidFileName = "Level name was invalid. Enter a new name: "
    static let messageForLoadLevel_emptyLevels = "There are no levels to load."
    static let messageForSaveLevelFailure = "Unable to Save Data!"
    static let messageForLoadLevelFailure = "Unable to Load Data!"
    static let messageForDocumentDirectoryAccessFailure = "Unable to access document directory!"
    static let messageForScreenshotFail = "Unable to take screenshot when saving game."
    static let messageForScreenshotSaveFail = "Unable to save screenshot image file to disk."
    static let messageForDeleteLevel = "Are you sure you want to delete this level?"
}
