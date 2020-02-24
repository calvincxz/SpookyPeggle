//
//  GameLevel.swift
//  PeggleGame
//
//  Created by Calvin Chen on 25/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import CoreGraphics

/**
`GameLevel` is an abstract data structure that represents a game level which
 contains all the pegs
*/
class GameLevel: Codable {
    private var pegsInLevel = Set<Peg>()

    func loadGameLevel(gameLevel: GameLevel) {
        resetLevel()
        for peg in gameLevel.getPegsInLevel() {
            self.addToLevel(addedPeg: peg)
        }
    }

    /// Removes all pegs from the game level.
    func resetLevel() {
        pegsInLevel.removeAll()
    }

    /// Adds the given peg to the game level.
    func addToLevel(addedPeg: Peg) {
        guard canInsertPeg(peg: addedPeg) else {
            return
        }
        pegsInLevel.insert(addedPeg)
        print("added PEG")
    }

    /// Removes the given peg from the game level.
    /// Nothing happens when peg does not exist.
    func removeFromLevel(removedPeg: Peg) {
        pegsInLevel.remove(removedPeg)
    }

    /// Checks if insertion of new peg in the game level is possible.
    func canInsertPeg(peg: Peg) -> Bool {

        let overlapCount = pegsInLevel.filter({ $0.intersects(otherPeg: peg) }).count

        return overlapCount == 0
    }

    /// Finds the peg at a certain location.
    /// - Returns: the peg if found
    /// If the peg does not exist in the game level, returns nil
    func findPeg(at location: CGPoint) -> Peg? {
        return pegsInLevel.first(where: { $0.contains(point: location) })
    }

    /// Returns a list of pegs currently in the game level.
    /// - Returns: a set of `Peg`s
    func getPegsInLevel() -> Set<Peg> {
        return pegsInLevel
    }

}
