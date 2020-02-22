//
//  PegImageView.swift
//  PS2
//
//  Created by Calvin Chen on 23/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

/**
`PegImageView` is a class which represents
 the peg that user sees.
*/
class PegImageView: UIImageView {

    private var pegType: PegType

    init(diameter: CGFloat, centre: CGPoint, pegType: PegType) {
        self.pegType = pegType
        let frame = CGRect(x: centre.x - diameter / 2, y: centre.y - diameter / 2, width: diameter, height: diameter)
        super.init(frame: frame)
        self.image = GameDisplayHelper.getPegImage(of: pegType)

    }

    /// Constructs  a `PegImageView` from a `Peg`
    convenience init?(peg: Peg) {
        if let peg = peg as? CirclePeg {
            self.init(circlePeg: peg)
        } else if let peg = peg as? TrianglePeg {
            self.init(trianglePeg: peg)
        } else {
            return nil
        }
    }

    convenience init(circlePeg: CirclePeg) {
        let centre = circlePeg.getCentrePoint()
        let diameter = circlePeg.getDiameter()
        self.init(diameter: diameter, centre: centre, pegType: circlePeg.getPegType())
    }

    convenience init(trianglePeg: TrianglePeg) {
        let centre = trianglePeg.centre
        let diameter = trianglePeg.diameter
        self.init(diameter: diameter, centre: centre, pegType: trianglePeg.pegType)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Moves the center of a `PegImageView`
    func moveTo(point: CGPoint) {
        self.center = point
    }

    /// Changes the image of a `PegImageView` to a lighted one
    func lightUp() {
        self.image = GameDisplayHelper.getLightedPegImage(of: pegType)
    }

    /// Slowly sets the alpha to 0 with animation
    func fadeOut() {
        UIView.animate(withDuration: 1.2, delay: 0, options: UIView.AnimationOptions.curveEaseIn,
                       animations: { self.alpha = 0 })

    }

}
