//
//  PeggleGameEngine.swift
//  PS3
//
//  Created by Calvin Chen on 3/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

/**
The `PeggleGameEngine` deals with logic specific to the Peggle Game.
 It contains a `PhysicsEngine`to deal with movement and collision of game objects.
 It contains a `ContactDelegate` which handle contact events.
*/
class PeggleGameEngine {

    private let physicsEngine: PhysicsEngine
    private var gameObjects = Set<GamePeg>()
    private var ballObject: GameBall?
    weak var contactDelegate: ContactDelegate?
    private var bucket: GameBucket
    var area: CGSize
    private var spookyCount = 0

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
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: .current, forMode: .common)
    }

    /// Main method for running the game.
    @objc private func updateFrame(displayLink: CADisplayLink) {
        guard let ball = ballObject else {
            return
        }

        handleBottomExit(ball: ball)
        handleWallCollision(ball: ball, bucket: bucket)
        handleBallCollisionWithPeg(ball: ball)
        handleBallMovement(ball: ball)
        handleBucketMovement(bucket: bucket)
        handleBucketCollision(ball: ball)
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
        return false
        //return !gameObjects.contains(where: { $0.getPegType() == PegType.orange })
    }

    /// Gets the current ball in game from the `PeggleGameEngine`.
    func getBall() -> GameObject? {
        return ballObject
    }

    func addBucket() {
        self.bucket = GameBucket(area: area)
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
        bucket.resetVelocity()
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

    private func handleBucketMovement(bucket: GameBucket) {
        bucket.move()
        contactDelegate?.handleBucketMovement(bucket: bucket)
    }

    /// Checks if ball will collide with a peg in the `PhysicsEngine`and
    /// updates the velocity of the ball in the game.
    private func handleBallCollisionWithPeg(ball: GameObject) {
        for peg in gameObjects where ball.willCollide(other: peg) {

            ball.changeVelocityAfter(collisionWith: peg, energyLoss: Settings.energyLoss)
            peg.hitByBall()
            contactDelegate?.handlePegHitByBall(pegObject: peg)
            if peg.getHitCount() == 1 {
                handlePegEffect(specialPeg: peg)
            }
        }
    }

    private func handlePegEffect(specialPeg: GamePeg) {
        switch specialPeg.getPegType() {
        case .green:
//            for peg in gameObjects where specialPeg.centre.distanceTo(other: peg.centre) <= Settings.defaultBallDiameter * 5 {
//                peg.hitByBall()
//                contactDelegate?.handlePegHitByBall(pegObject: peg)
//            }
            spookyCount += 1
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
        guard spookyCount <= 0 else {
            print("spooky++")
            removePegsAfterBallExit()
            ball.centre = CGPoint(x: ball.centre.x, y: 20)
            spookyCount -= 1
            return
        }

        removePegsAfterBallExit()
        removeBall()
    }

    /// Removes relevant pegs from the `PeggleGameEngine` after ball exits.
    private func removePegsAfterBallExit() {
        for object in gameObjects where object.getHitCount() > 0 {
            contactDelegate?.handlePegRemoval(pegObject: object)
            removeFromGameEngine(gameObject: object)
            score += 100
        }
    }

    /// Checks if ball has collided with the wall in the `PhysicsEngine`.
    /// Updates velocity of the ball in the game.
    private func handleWallCollision(ball: GameObject, bucket: GameBucket) {
        if physicsEngine.checkSideCollision(object: ball) {
            ball.reflectVelocityInDirectionX()
        }

        if physicsEngine.checkSideCollision(rectangularObject: bucket) {
            bucket.reflectVelocityInDirectionX()
        }
    }

    private func handleBucketCollision(ball: GameObject) {
        if bucket.willCollide(ball: ball) {
            if bucket.checkEnterBucket(ball: ball) {
                removePegsAfterBallExit()
                removeBall()
                ballCount += 10
            } else {
                ball.changeVelocityAfter(polygonObject: bucket, energyLoss: Settings.energyLoss)
            }
        }
    }
}
