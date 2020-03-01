//
//  GamePlayController.swift
//  PS3
//
//  Created by Calvin Chen on 3/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

/**
The `GamePlayController` is the controller class for game play logic which
 interacts mainly with the the model class:`PeggleGameEngine` and
 the view class:`PegBoardView`
*/
class GamePlayController: UIViewController {

    @IBOutlet private weak var ballView: UIImageView!
    @IBOutlet private weak var cannon: UIImageView!
    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var cannonView: CannonView!
    @IBOutlet private weak var pegBoard: PegBoardView!
    @IBOutlet private weak var bucketView: BucketView!
    @IBOutlet private weak var playerMessage: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var ballCountLabel: UILabel!
    @IBOutlet private weak var orangePegCountLabel: UILabel!

    /// Hides the status bar at the top
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // Force unwrapping is used since engine must be initialised by viewDidAppear()
    private var engine: PeggleGameEngine!
    private var gameLevel: GameLevel?
    private var gameObjectToImageViewDictionary = [GameObject: PegImageView]()
    private var ballOnFireCount = 0 {
        didSet {
            if ballOnFireCount == 0 {
                ballView.image = #imageLiteral(resourceName: "ball")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// Creates game engine if engine is not initialized.
    /// Loads level from previous controller
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MusicPlayer.playInGameMusic()
        cannonView.setUpCannonView(cannon: cannon, ball: ballView)
        guard engine == nil else {
            return
        }
        initializeGameEngine()
        if let level = gameLevel {
            reloadLevel(gameLevel: level)
            return
        }
    }

    func setGameLevel(gameLevel: GameLevel?) {
        self.gameLevel = gameLevel
    }

    /// Resets the engine and view.
    private func reloadLevel(gameLevel: GameLevel) {
        ballOnFireCount = 0
        playerMessage.text = ""
        pegBoard.clearBoard()
        engine.resetEngine()
        cannonView.resetCannonDirection()
        cannonView.reloadBall()
        pegBoard.addBucketToBoard(bucket: bucketView)
        setupGameLevel(gameLevel: gameLevel)
    }

    /// Initialize game engine after constraints for `PegBoardView` has been updated
    private func initializeGameEngine() {
        let area = pegBoard.bounds.size
        engine = PeggleGameEngine(area: area)
        engine.contactDelegate = self
    }

    /// Loads the game pegs from a game level.
    private func setupGameLevel(gameLevel: GameLevel) {
        for newPeg in gameLevel.getPegsInLevel() {
            let scaleX = pegBoard.frame.width / gameLevel.getAreaSize().width
            let scaleY = pegBoard.frame.height / gameLevel.getAreaSize().height
            let peg = newPeg.moveTo(location: newPeg.centre.moveTo(scaleX: scaleX, scaleY: scaleY))
            addToModelView(peg: peg)
        }
        engine.initializeOrangePegStatus()
    }

    /// Adds a game peg to both the `PeggleGameEngine` and `PegBoardView`
    private func addToModelView(peg: Peg) {
        let pegImageView = PegImageView(peg: peg)
        let pegObject = GamePeg(peg: peg)
        pegBoard.addPegToBoard(peg: pegImageView)
        engine.addToGameEngine(gameObject: pegObject)
        gameObjectToImageViewDictionary[pegObject] = pegImageView
    }
}

/**
`ContactDelegate` methods can be found below. These methods allow the `PeggleGameEngine`
 to communicate with the `GamePlayController`.
*/
extension GamePlayController: ContactDelegate {

    func handlePegRemoval(pegObject: GameObject) {
        let pegImageView = gameObjectToImageViewDictionary[pegObject]
        pegImageView?.fadeOut()
        gameObjectToImageViewDictionary[pegObject] = nil
    }

    func handleBallExit() {
        pegBoard.removeBallFromBoard()
        if engine.checkWinStatus() {
            performSegue(withIdentifier: "gameToEnd", sender: self)
        } else if engine.ranOutOfBalls {
            performSegue(withIdentifier: "gameToEnd", sender: self)
        } else {
            cannonView.reloadBall()
        }
    }

    func handleBallMovement(ballObject: GameObject) {
        pegBoard.getBall()?.moveTo(point: ballObject.centre)
    }

    func handleBucketMovement(bucket: GameBucket) {
        pegBoard.getBucket()?.moveTo(point: bucket.centre)
    }

    func handlePegHitByBall(pegObject: GameObject) {
        MusicPlayer.playPegHitSound()
        let pegImageView = gameObjectToImageViewDictionary[pegObject]
        pegImageView?.lightUp()
    }

    func updateScore(score: Int) {
        scoreLabel.text = "Score: \(score)"
    }

    func updateBallCount(ballCount: Int) {
        ballCountLabel.text = "Ball count: \(ballCount)"
    }

    func updateMessage(message: String) {
        playerMessage.text = message
    }

    func handleSpecialEffect(peg: GameObject) {
        guard let pegView = gameObjectToImageViewDictionary[peg] else {
            return
        }
        pegBoard.createSmokeEffect(peg: pegView)
    }

    func updateOrangePegStatus(currentCount: Int, totalCount: Int) {
        let lightedCount = totalCount - currentCount
        orangePegCountLabel.text = "Orange Pegs Hit: \n" + "\(lightedCount) / \(totalCount)"
    }

    func handleBucketAppearance(isSpooky: Bool) {
        if isSpooky {
            bucketView.close()
            pegBoard.addBallGlow(colour: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1))

        } else {
            bucketView.open()
        }
    }

    func handleBallCollision() {
        MusicPlayer.playBucketCollisionSound()
    }

    func activateFireBallNextTurn() {
        ballView.image = #imageLiteral(resourceName: "peg-red-glow")
        ballView.backgroundColor = nil
        ballView.layer.cornerRadius = 0.5 * ballView.bounds.size.width
        ballView.clipsToBounds = true
        ballOnFireCount += 1
    }
}

/// Extension to handle gestures
extension GamePlayController {
    /// Handles the rotation of the `cannonView`.
    @IBAction private func handleCannonRotation(_ sender: UIPanGestureRecognizer) {
        guard engine.readyToStart else {
            return
        }
        let translation = sender.translation(in: pegBoard)
        cannonView.rotate(translation: translation)
        sender.setTranslation(CGPoint.zero, in: pegBoard)
    }

    /// Starts the game by firing the ball from the cannon.
    @IBAction private func handleGameStart(_ sender: UITapGestureRecognizer) {
        guard engine.readyToStart else {
            return
        }
        let ballLaunchPoint = pegBoard.convert(ballView.center, from: cannonView)
        let ballOriginPoint = pegBoard.convert(cannon.center, from: cannonView)
        let angle = GameDisplayHelper.getAngle(of: ballLaunchPoint, from: ballOriginPoint)
        shootBall(at: angle)
    }

    /// Adds the ball to the game engine and peg board.
    /// Passes the control of game to the game engine.
    private func shootBall(at angle: CGFloat) {
        MusicPlayer.playCannonSound()
        cannonView.removeBall()
        let ballLaunchPoint = pegBoard.convert(ballView.center, from: cannonView)
        let imageViewOfBall = BallView(centre: ballLaunchPoint)
        let ballObject = GameBall(centre: ballLaunchPoint)
        if ballOnFireCount > 0 {
            imageViewOfBall.setOnFire()
            ballObject.setOnFire()
            ballOnFireCount -= 1
        }
        engine.addBall(ball: ballObject, angle: angle)
        pegBoard.addBallToBoard(ball: imageViewOfBall)
    }
}

/// Extension to handle segues
extension GamePlayController {
    @IBAction private func backToMenu(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EndGameViewController {
            let target = segue.destination as? EndGameViewController
            target?.setGameState(state: engine.checkWinStatus(), score: scoreLabel.text ?? "")
        }

        if let level = gameLevel {
            reloadLevel(gameLevel: level)
        }
    }
}
