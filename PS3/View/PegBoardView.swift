//
//  PegBoardView.swift
//  PS2
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
    var ball: BallView?

    func getBall() -> BallView? {
        return ball
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
        self.addSubview(peg)
    }

    func removePegFromBoard(peg: PegImageView) {
        peg.removeFromSuperview()
    }

    func clearBoard() {
        ball = nil
        for peg in self.subviews {
            peg.removeFromSuperview()
        }
    }
}
