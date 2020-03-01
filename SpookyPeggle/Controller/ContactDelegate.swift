//
//  ContactDelegate.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 14/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

/**
The `ContactDelegate` handles events for the Peggle Game.
*/
protocol ContactDelegate: AnyObject {
    /// Handles the event of peg removal
    func handlePegRemoval(pegObject: GameObject)

    /// Handles the event of the ball exiting the game
    func handleBallExit()

    /// Handles the ball movement event
    func handleBallMovement(ballObject: GameObject)

    /// Handles the event of a peg being hit by the ball
    func handlePegHitByBall(pegObject: GameObject)

    /// Handles the event of a score update
    func updateScore(score: Int)

    /// Handles the event of a ball count update
    func updateBallCount(ballCount: Int)

    func handleBucketMovement(bucket: GameBucket)

    func updateMessage(message: String)

    func handleSpecialEffect(peg: GameObject)

    func updateOrangePegStatus(currentCount: Int, totalCount: Int)

    func handleBucketAppearance(isSpooky: Bool)

    func handleBallCollision()

    func activateFireBallNextTurn()

}
