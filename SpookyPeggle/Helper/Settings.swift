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
    // Palette settings
    static let defaultPegDiameter = CGFloat(40)
    static let defaultTrianglePegLength = CGFloat(40)
    static let defaultBallDiameter = CGFloat(40)
    static let lowAlphaForUnselectedButton = CGFloat(0.5)
    static let darkAlphaForSelectedButton = CGFloat(1)

    // Ball settings
    static let initialVelocityForBall = CGFloat(15)
    static let initialVelocityForBucket = CGVector(dx: 3, dy: 0)
    static let accelerationForBall = CGVector(dx: 0, dy: 0.2)
    static let maxVelocityForBall = CGFloat(10)

    // Bucket settings
    static let bucketWidth = CGFloat(220)
    static let bucketHeight = CGFloat(40)
    static let defaultBucketHoleLength = CGFloat(180)

    // Game settings
    static let energyLoss = CGFloat(0.8)
    static let initialBallCount = 5
    static let cannonRotationPerGesture = CGFloat(0.02)
    static let maximumCannonRotationAngle = CGFloat(1.2)
    static let minScoreForFreeBall = 2_000
    static let spookyBlastMaxLength = Settings.defaultPegDiameter * 3
    static let bucketWidthIncreaseScaleForPowerUp = CGFloat(1.5)

    // Settings for level preview
    static let preloadedFileNames = ["PreloadLevel3.json", "PreloadLevel2.json", "PreloadLevel1.json",
                                     "PreloadLevel3.png", "PreloadLevel2.png", "PreloadLevel1.png"]
    static let preloadedLevelNames = ["PreloadLevel1", "PreloadLevel2", "PreloadLevel3"]

    // User-defined variables
    static var gameMaster: GameMaster? = .Pumpkin

    // Alert messages
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
    static let messageForPreloadLevelOverwriteError = "File name matches preloaded levels! Kindly use another name."
    static let messageForDeleteFail = "Unable to delete game level!"
    static let messageForDeletePreloadLevel = "Preloaded levels cannot be deleleted!"

    // In-game messages
    static let messageForFreeBallFromScore = "Free ball from score!"
    static let messageForFreeBallFromBucket = "Free ball from bucket!"
    static let messageForBucketHit_NoFreeBall = "No Luck!"
    static let messageForBatPowerUp = "SPOOKY BLAAAAST!"
    static let messageForWizardPowerUp = "FIREEEEEEE!"
}
