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
        self.addSubview(bucket)
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

    func createSmokeEffect(peg: PegImageView) {

        let diameter = Settings.spookyBlastMaxLength * 2
        let frame = CGRect(x: peg.center.x - diameter / 2, y: peg.center.y - diameter / 2,
                           width: diameter, height: diameter)

        //let smokeFrame = peg.frame.insetBy(dx: scale, dy: scale)
        let smoke = UIImageView(frame: frame)

        smoke.image = #imageLiteral(resourceName: "smoke")
        smoke.layer.cornerRadius = 0.5 * smoke.bounds.size.width
        smoke.clipsToBounds = true

        addSubview(smoke)

        UIView.animate(withDuration: 1.5, delay: 0, options: UIView.AnimationOptions.curveEaseIn,
                       animations: { smoke.alpha = 0 }, completion: { _ in smoke.removeFromSuperview() })
        //smoke.removeFromSuperview()

    }
}
