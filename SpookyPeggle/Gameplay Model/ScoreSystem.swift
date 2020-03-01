//
//  ScoreSystem.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 27/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation

enum ScoreSystem {
    private static var baseScore = 0
    private static var pegs: [GamePeg] = [GamePeg]()
    private static var dictionary = [PegType: Int]()

    /// Adds peg to score system
    static func addPegToRound(peg: GamePeg) {
        pegs.append(peg)
        let currentCount = dictionary[peg.getPegType()] ?? 0
        dictionary[peg.getPegType()] = currentCount + 1
        baseScore += getScoreForPeg(peg: peg)
    }

    /// Gets the score for the round
    static func getScoreForRound() -> Int {
        let result = baseScore * dictionary.values.count
        resetScore()
        return result
    }

    private static func resetScore() {
        baseScore = 0
        pegs = []
        dictionary = [PegType: Int]()
    }

    private static func getScoreForPeg(peg: GamePeg) -> Int {
        switch peg.getPegType() {
        case .blue:
            return 10
        case .green:
            return 10
        case .orange:
            return 100
        case .purple:
            return 500
        }
    }
}
