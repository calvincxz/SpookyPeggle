//
//  GameLevelTest.swift
//  PeggleGameTests
//
//  Created by Calvin Chen on 29/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import XCTest
@testable import SpookyPeggle

class GameLevelTest: XCTestCase {
    let pegOne = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: 0, y: 0))
    let pegOneWithSameAttributes = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: 0, y: 0))
    let pegOne_differentColour = Peg(type: PegType.orange, circleOfCentre: CGPoint(x: 0, y: 0))
    let pegTwo = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: 0, y: 50))

    func testConstruct() {
        let gameLevel = GameLevel()
        XCTAssertEqual(gameLevel.getPegsInLevel(), [], "Level should be empty")
    }

    func testAddToLevel_emptyLevel() {
        let gameLevel = GameLevel()
        gameLevel.addToLevel(addedPeg: pegOne)
        XCTAssertEqual(gameLevel.getPegsInLevel(), [pegOne], "Level should contain peg")
    }

    func testAddToLevel_nonEmptyLevel_nonExistingPeg() {
        let gameLevel = GameLevel()
        gameLevel.addToLevel(addedPeg: pegOne)
        gameLevel.addToLevel(addedPeg: pegTwo)
        XCTAssertEqual(gameLevel.getPegsInLevel(), [pegOne, pegTwo], "Level should contain pegs")
    }

    func testAddToLevel_nonEmptyLevel_existingPeg() {
        let gameLevel = GameLevel()

        gameLevel.addToLevel(addedPeg: pegOne)
        gameLevel.addToLevel(addedPeg: pegOneWithSameAttributes)
        XCTAssertEqual(gameLevel.getPegsInLevel(), [pegOne], "Level should contain 1 peg")
        XCTAssertEqual(gameLevel.getPegsInLevel(), [pegOneWithSameAttributes], "Level should contain 1 peg")
    }

    func testRemoveFromLevel_existingPeg_sameConstructedPeg() {
        let gameLevel = GameLevel()
        gameLevel.addToLevel(addedPeg: pegOne)
        gameLevel.removeFromLevel(removedPeg: pegOne)
        XCTAssertEqual(gameLevel.getPegsInLevel(), [], "Peg should be removed")
    }

    func testRemoveFromLevel_existingPeg_differentConstructedPeg() {
        let gameLevel = GameLevel()
        gameLevel.addToLevel(addedPeg: pegOne)
        gameLevel.removeFromLevel(removedPeg: pegOneWithSameAttributes)
        XCTAssertEqual(gameLevel.getPegsInLevel(), [], "Peg should be removed")
    }

    func testRemoveFromLevel_nonExistingPeg() {
        let gameLevel = GameLevel()
        gameLevel.addToLevel(addedPeg: pegOne)
        gameLevel.removeFromLevel(removedPeg: pegOne_differentColour)
        XCTAssertEqual(gameLevel.getPegsInLevel(), [pegOne], "Peg should not be removed")
    }

    func testCanInsertPeg_nonOverlappingPeg() {
        let gameLevel = GameLevel()
        gameLevel.addToLevel(addedPeg: pegOne)
        let nonOverlappingPeg = Peg(type: PegType.blue,
                                    circleOfCentre: CGPoint(x: 0, y: Settings.defaultPegDiameter))
        XCTAssertTrue(gameLevel.canInsertPeg(peg: nonOverlappingPeg), "Should be able to insert peg")
    }

    func testCanInsertPeg_overlappingPeg() {
        let gameLevel = GameLevel()

        gameLevel.addToLevel(addedPeg: pegOne)
        let overlappingPeg = Peg(type: PegType.blue,
                                 circleOfCentre: CGPoint(x: 0, y: Int(Settings.defaultPegDiameter - 1)))
        XCTAssertFalse(gameLevel.canInsertPeg(peg: overlappingPeg), "Should not be able to insert peg")
    }

    func testCanInsertPeg_surroundedByFourPeg_success() {
        let gameLevel = GameLevel()
        let defaultDiameter = Int(Settings.defaultPegDiameter)
        let twiceOfDiameter = 2 * defaultDiameter

        let leftPeg = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: 0, y: defaultDiameter))
        let rightPeg = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: twiceOfDiameter, y: defaultDiameter))
        let topPeg = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: defaultDiameter, y: 0))
        let bottomPeg = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: defaultDiameter, y: twiceOfDiameter))
        gameLevel.addToLevel(addedPeg: leftPeg)
        gameLevel.addToLevel(addedPeg: rightPeg)
        gameLevel.addToLevel(addedPeg: topPeg)
        gameLevel.addToLevel(addedPeg: bottomPeg)

        let centrePeg = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: defaultDiameter, y: defaultDiameter))
        XCTAssertTrue(gameLevel.canInsertPeg(peg: centrePeg), "Should be able to insert peg")

    }

    func testCanInsertPeg_surroundedByFourPeg_failure() {
        let gameLevel = GameLevel()
        let defaultDiameter = Int(Settings.defaultPegDiameter)
        let twiceOfDiameter = 2 * defaultDiameter

        let leftPeg = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: 0, y: defaultDiameter))
        let rightPeg = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: twiceOfDiameter, y: defaultDiameter))
        let topPeg = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: defaultDiameter, y: 0))
        let bottomPeg = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: defaultDiameter, y: twiceOfDiameter))
        gameLevel.addToLevel(addedPeg: leftPeg)
        gameLevel.addToLevel(addedPeg: rightPeg)
        gameLevel.addToLevel(addedPeg: topPeg)
        gameLevel.addToLevel(addedPeg: bottomPeg)

        let centrePegDeviatedLeft = Peg(type: PegType.blue,
                                        circleOfCentre: CGPoint(x: defaultDiameter - 1, y: defaultDiameter))
        let centrePegDeviatedRight = Peg(type: PegType.blue,
                                         circleOfCentre: CGPoint(x: defaultDiameter + 1, y: defaultDiameter))
        let centrePegDeviatedDown = Peg(type: PegType.blue,
                                        circleOfCentre: CGPoint(x: defaultDiameter, y: defaultDiameter - 1))
        let centrePegDeviatedUp = Peg(type: PegType.blue,
                                      circleOfCentre: CGPoint(x: defaultDiameter, y: defaultDiameter + 1))

        XCTAssertFalse(gameLevel.canInsertPeg(peg: centrePegDeviatedLeft), "Should not be able to insert peg")
        XCTAssertFalse(gameLevel.canInsertPeg(peg: centrePegDeviatedRight), "Should not be able to insert peg")
        XCTAssertFalse(gameLevel.canInsertPeg(peg: centrePegDeviatedDown), "Should not be able to insert peg")
        XCTAssertFalse(gameLevel.canInsertPeg(peg: centrePegDeviatedUp), "Should not be able to insert peg")
    }
}
