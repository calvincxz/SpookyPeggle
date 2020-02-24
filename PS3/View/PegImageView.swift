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
    private var initialState: CGAffineTransform?
    private var rotation = CGFloat.zero

    init(diameter: CGFloat, centre: CGPoint, pegType: PegType, rotation: CGFloat) {
        self.pegType = pegType
        let frame = CGRect(x: centre.x - diameter / 2, y: centre.y - diameter / 2, width: diameter, height: diameter)
        super.init(frame: frame)
        image = GameDisplayHelper.getPegImage(of: pegType)
        self.rotation = rotation
        transform = transform.rotated(by: rotation)
    }

    func getRotatedAngle() -> CGFloat {
        return rotation
    }

    /// Constructs  a `PegImageView` from a `Peg`
    convenience init(peg: Peg) {
        switch peg.shape {
        case .Circle:
            self.init(circlePeg: peg)
        case .Triangle:
            self.init(trianglePeg: peg)
        }
    }

    convenience init(circlePeg: Peg) {
        let centre = circlePeg.centre
        let diameter = circlePeg.physicalShape.radius * 2
        self.init(diameter: diameter, centre: centre, pegType: circlePeg.pegType, rotation: circlePeg.rotation)
    }

    convenience init(trianglePeg: Peg) {
        let centre = trianglePeg.centre
        let diameter = trianglePeg.physicalShape.length
        // print(trianglePeg.rotation.description)
        self.init(diameter: diameter, centre: centre, pegType: trianglePeg.pegType, rotation: trianglePeg.rotation)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applySelectedEffect() {
        lightUp()
    }

    func applyUnselectedEffect() {
        dimDown()
    }

    /// Moves the center of a `PegImageView`
    func moveTo(point: CGPoint) {
        self.center = point
    }

    func dimDown() {
        image = GameDisplayHelper.getPegImage(of: pegType)
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

    func rotate(by angle: CGFloat) {
        rotation += angle
        transform = transform.rotated(by: angle)
    }

    func setInitialPosition() {
        initialState = transform
    }

    func returnToInitialPosition() {
        transform = initialState ?? CGAffineTransform.identity
    }

}
