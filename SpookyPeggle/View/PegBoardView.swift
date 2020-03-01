//
//  PegBoardView.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 24/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

/**
`PegBoardView` is a class which represents the
 gameplay screen which contains the peg images that user sees.
*/
class PegBoardView: UIView {
    private var ball: BallView?
    private var bucket: BucketView?
    private var pegs = [PegImageView]()

    func getBall() -> BallView? {
        return ball
    }

    func getBucket() -> BucketView? {
        return bucket
    }

    func addBucketToBoard(bucket: BucketView) {
        self.bucket = bucket
    }

    func addBallToBoard(ball: BallView) {
        self.addSubview(ball)
        self.ball = ball
    }

    func removeBallFromBoard() {
        ball?.removeFromSuperview()
        ball = nil
    }

    func addPegToBoard(peg: PegImageView) {
        pegs.append(peg)
        self.addSubview(peg)
    }

    func removePegFromBoard(peg: PegImageView) {
        peg.removeFromSuperview()
    }

    func clearBoard() {
        removeBallFromBoard()
        for peg in pegs {
            peg.removeFromSuperview()
        }
    }

    func addBallGlow(colour: CGColor) {
        guard let ball = ball else {
            return
        }
        ball.layer.shadowOffset = .zero
        ball.layer.shadowColor = colour
        ball.layer.shadowRadius = 10
        ball.layer.shadowOpacity = 1
        ball.layer.shadowPath = UIBezierPath(rect: ball.bounds).cgPath
    }

    func removeBallGlow() {
        ball?.layer.shadowOpacity = 0
    }

    func createSmokeEffect(peg: PegImageView) {
        let smoke = GameDisplayHelper.createSmokeImageView(centre: peg.center)
        addSubview(smoke)

        UIView.animate(withDuration: 1.5, delay: 0, options: UIView.AnimationOptions.curveEaseIn,
                       animations: { smoke.alpha = 0 }, completion: { _ in smoke.removeFromSuperview() })
    }
}
