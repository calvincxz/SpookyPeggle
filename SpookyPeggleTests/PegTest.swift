//
//  PegTest.swift
//  PeggleGameTests
//
//  Created by Calvin Chen on 26/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import XCTest
@testable import SpookyPeggle

class PegTest: XCTestCase {

    let pegOne = Peg(type: PegType.blue, circleOfCentre: CGPoint(x: 25, y: 25))
    let pegTwo = Peg(type: PegType.orange, circleOfCentre: CGPoint(x: 50, y: 50))
    let defaultPegType = PegType.blue

    func testGetCentrePoint() {
        let circleOfCentre = CGPoint(x: 10, y: 10)
        let peg = Peg(type: defaultPegType, circleOfCentre: circleOfCentre)
        XCTAssertEqual(peg.centre, circleOfCentre, "Wrong circleOfCentre")
    }

    func testGetPegType() {
        let circleOfCentre = CGPoint(x: 10, y: 10)
        let pegType = PegType.orange
        let peg = Peg(type: pegType, circleOfCentre: circleOfCentre)
        XCTAssertEqual(peg.pegType, pegType, "Wrong peg type")
    }

    func testIntersects_nonOverlappingPeg_returnFalse() {
        let nonOverlappingPeg = Peg(type: PegType.orange, circleOfCentre: CGPoint(x: 75, y: 25))
        XCTAssertFalse(pegOne.intersects(otherPeg: nonOverlappingPeg), "Peg should not intersect non-overlapping peg")
    }

    func testIntersects_overlappingPeg_returnTrue() {
        let overlappingPeg = Peg(type: PegType.orange, circleOfCentre: CGPoint(x: 0, y: 0))
        XCTAssertTrue(pegOne.intersects(otherPeg: overlappingPeg), "Peg should intersect overlapping peg")
    }

    func testContains_validPoint_returnTrue() {
        let validPoint = CGPoint(x: 25, y: 49)
        XCTAssertTrue(pegOne.contains(point: validPoint), "Peg should contain point")
    }

    func testContains_invalidPoint_returnFalse() {
        let invalidPoint = CGPoint(x: 50, y: 50)
        XCTAssertFalse(pegOne.contains(point: invalidPoint), "Peg should not contain point")
    }

    func testEquals_DifferentPeg() {
        XCTAssertNotEqual(pegOne, pegTwo, "Peg should not be equal to different peg")

    }

    func testEquals_differentPegSameAttributes() {
        let differentPegWithSameAttributes = Peg(type: pegOne.pegType, circleOfCentre: pegOne.centre)
        XCTAssertEqual(pegOne, differentPegWithSameAttributes, "Pegs should be equal")
    }

    func testEquals_SamePeg() {
        XCTAssertEqual(pegOne, pegOne, "Peg should equal itself")
    }

    func testHashValue_DifferentPeg() {
        XCTAssertNotEqual(pegOne.hashValue, pegTwo.hashValue, "Pegs' hash value should not be equal")

    }

    func testHashValue_differentPegSameAttributes() {
        let differentPegWithSameAttributes = Peg(type: pegOne.pegType, circleOfCentre: pegOne.centre)
        XCTAssertEqual(pegOne.hashValue, differentPegWithSameAttributes.hashValue, "Pegs' hash value should be equal")
    }

    func testHashValue_SamePeg() {
        XCTAssertEqual(pegOne.hashValue, pegOne.hashValue, "Peg should equal itself")
    }

}
