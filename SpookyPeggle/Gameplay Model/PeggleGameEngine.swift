//
//  PeggleGameEngine.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 3/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit
import PhysicsEngine

/**
The `PeggleGameEngine` deals with logic specific to the Peggle Game.
 It contains a `PhysicsEngine`to deal with movement and collision of game objects.
 It contains a `ContactDelegate` which handle contact events.
*/
class PeggleGameEngine {

    weak var contactDelegate: ContactDelegate?
    private let physicsEngine: PhysicsEngine
    private var gameObjects = Set<GamePeg>()
    private var ballObject: GameBall?
    private var bucket: GameBucket
    private var area: CGSize
    private var spookyCount = 0 {
        didSet {
            spookyCount > 0 ? bucket.close() : bucket.open()
            contactDelegate?.handleBucketAppearance(isSpooky: spookyCount > 0)
            contactDelegate?.updateMessage(message: "Spooky Ball: \(spookyCount)")
        }
    }

    private var totalOrangePegCount: Int?
    private var currentOrangePegCount: Int? {
        didSet {
            guard let current = currentOrangePegCount, let total = totalOrangePegCount else {
                return
            }
            if current == 1 {
                MusicPlayer.playCloseToWinSound()
            }
            contactDelegate?.updateOrangePegStatus(currentCount: current, totalCount: total)
        }
    }

    private var score = 0 {
        didSet {
            contactDelegate?.updateScore(score: score)
        }
    }

    private var ballCount = Settings.initialBallCount {
        didSet {
            contactDelegate?.updateBallCount(ballCount: ballCount)
        }
    }

    var readyToStart: Bool {
        return ballObject == nil && ballCount > 0
    }

    var ranOutOfBalls: Bool {
        return ballCount == 0
    }

    /// Creates a `PeggleGameEngine` with a `PhysicsEngine` of a given area.
    init(area: CGSize) {
        self.area = area
        self.physicsEngine = PhysicsEngine(area: area)
        self.bucket = GameBucket(area: area)
        let displayLink = CADisplayLink(target: self, selector: #selector(updateFrame))
        displayLink.preferredFramesPerSecond = 40
        displayLink.add(to: .current, forMode: .common)
    }

    /// Main method for running the game.
    @objc private func updateFrame(displayLink: CADisplayLink) {
        handleBucketMovement(bucket: bucket)
        handleWallCollision(bucket: bucket)

        guard let ball = ballObject else {
            return
        }
        handleBottomExit(ball: ball)
        handleWallCollision(ball: ball)
        handleBallCollisionWithPeg(ball: ball)
        handleBucketCollision(ball: ball)
        handleBallMovement(ball: ball)
    }

    /// Resets the `PeggleGameEngine` for a new game.
    func resetEngine() {
        score = 0
        ballCount = Settings.initialBallCount
        physicsEngine.resetPhysicsEngine()
        gameObjects.removeAll()
        ballObject = nil
        bucket.resetVelocity()
    }

    /// Returns true if there are no orange pegs in the `PeggleGameEngine`.
    func checkWinStatus() -> Bool {
        return !gameObjects.contains(where: { $0.getPegType() == PegType.orange })
    }

    /// Gets the current ball in game from the `PeggleGameEngine`.
    func getBall() -> GameObject? {
        return ballObject
    }

    func initializeOrangePegStatus() {
        let count = gameObjects.filter { $0.getPegType() == PegType.orange }.count
        totalOrangePegCount = count
        currentOrangePegCount = count
    }

    /// Loads a ball to the `PeggleGameEngine`for starting the game.
    /// The ball is configured with the proper velocity and acceleration.
    func addBall(ball: GameBall, angle: CGFloat) {
        ballCount -= 1
        ball.velocity = GameDisplayHelper.getInitialVelocity(angle: angle)
        ball.acceleration = Settings.accelerationForBall
        self.ballObject = ball
    }

    /// Removes a ball to the `PeggleGameEngine`.
    func removeBall() {
        self.ballObject = nil
        contactDelegate?.handleBallExit()
    }

    /// Adds a  `GameObject` to the `PeggleGameEngine`.
    func addToGameEngine(gameObject: GamePeg) {
        gameObjects.insert(gameObject)
    }

    /// Removes a `GameObject` from the `PeggleGameEngine`.
    func removeFromGameEngine(gameObject: GamePeg) {
        gameObjects.remove(gameObject)
    }

    /// Handles movement of the ball.
    private func handleBallMovement(ball: GameBall) {
        ball.move()
        contactDelegate?.handleBallMovement(ballObject: ball)
    }

    /// Handles movement of the bucket
    private func handleBucketMovement(bucket: GameBucket) {
        bucket.move()
        contactDelegate?.handleBucketMovement(bucket: bucket)
    }

    /// Checks if ball will collide with a peg in the `PhysicsEngine`and
    /// updates the velocity of the ball in the game.
    private func handleBallCollisionWithPeg(ball: GameBall) {
        for peg in gameObjects where ball.willCollide(other: peg) {
            if !ball.isOnFire() {
                ball.changeVelocityAfter(collisionWith: peg, energyLoss: Settings.energyLoss)
            }

            handlePegHitEffect(peg: peg)

            guard peg.getHitCount() < 20 else {
                contactDelegate?.handlePegRemoval(pegObject: peg)
                removeFromGameEngine(gameObject: peg)
                ScoreSystem.addPegToRound(peg: peg)
                return
            }
        }
    }

    /// Handles the special effect for a power-up peg
    private func handlePowerUpEffect(specialPeg: GamePeg) {
        switch Settings.gameMaster {
        case .Bat:
            contactDelegate?.handleSpecialEffect(peg: specialPeg)
            for peg in gameObjects where specialPeg.centre.distanceTo(other: peg.centre)
                <= Settings.spookyBlastMaxLength {
                handlePegHitEffect(peg: peg)
            }
            contactDelegate?.updateMessage(message: Settings.messageForBatPowerUp)
        case .Pumpkin:
            spookyCount += 1
        case .FlameWizard:
            contactDelegate?.activateFireBallNextTurn()
            contactDelegate?.updateMessage(message: Settings.messageForWizardPowerUp)

        default:
            return
        }
    }

    /// Handles the effect when a peg gets hit by ball/power-up
    private func handlePegHitEffect(peg: GamePeg) {
        peg.hitByBall()
        contactDelegate?.handlePegHitByBall(pegObject: peg)
        guard peg.getHitCount() == 1 else {
            return
        }

        switch peg.getPegType() {
        case .green:
            handlePowerUpEffect(specialPeg: peg)
        case .orange:
            guard let current = currentOrangePegCount else {
                return
            }
            currentOrangePegCount = current - 1
        default:
            return
        }
    }

    /// Checks if ball has exited in the `PhysicsEngine`.
    /// Removes the ball and relevant pegs from the game.
    private func handleBottomExit(ball: GameObject) {
        guard physicsEngine.checkBottomCollision(object: ball) else {
            return
        }
        removePegsAfterBallExit()

        guard spookyCount <= 0 else {
            let areaTop = CGFloat(20)
            ball.centre = CGPoint(x: ball.centre.x, y: areaTop)
            spookyCount -= 1
            return
        }
        let scoreForRound = ScoreSystem.getScoreForRound()
        if scoreForRound > Settings.minScoreForFreeBall {
            ballCount += 1
            contactDelegate?.updateMessage(message: Settings.messageForFreeBallFromScore)
        }
        score += scoreForRound
        removeBall()
    }

    /// Removes relevant pegs from the `PeggleGameEngine` after ball exits.
    private func removePegsAfterBallExit() {
        for peg in gameObjects where peg.getHitCount() > 0 {
            contactDelegate?.handlePegRemoval(pegObject: peg)
            removeFromGameEngine(gameObject: peg)
            ScoreSystem.addPegToRound(peg: peg)
        }
    }

    /// Handles wall collision of ball using the `PhysicsEngine`
    private func handleWallCollision(ball: GameObject) {
        if physicsEngine.checkSideCollision(circularObject: ball) {
            ball.reflectVelocityInDirectionX()
        }
    }

    /// Handles wall collision of bucket using the `PhysicsEngine`
    private func handleWallCollision(bucket: GameBucket) {
        if physicsEngine.checkSideCollision(rectangularObject: bucket) {
            bucket.reflectVelocityInDirectionX()
        }
    }

    /// Handles bucket collision of ball
    private func handleBucketCollision(ball: GameObject) {
        if bucket.collidedWith(ball: ball) {
            if bucket.checkEnterBucket(ball: ball) {
                ballCount += 1
                contactDelegate?.updateMessage(message: Settings.messageForFreeBallFromBucket)
                removePegsAfterBallExit()
                removeBall()
            } else {
                contactDelegate?.handleBallCollision()
                contactDelegate?.updateMessage(message: Settings.messageForBucketHit_NoFreeBall)
                ball.changeVelocityAfter(collisionWith: bucket, energyLoss: Settings.energyLoss)
            }
        }
    }
}
