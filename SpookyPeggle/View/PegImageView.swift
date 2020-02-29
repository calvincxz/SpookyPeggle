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

    private let pegType: PegType
    private let pegShape: PegShape
    private var rotation = CGFloat.zero

    init(diameter: CGFloat, centre: CGPoint, pegType: PegType, shape: PegShape, rotation: CGFloat) {
        self.pegType = pegType
        self.pegShape = shape
        self.rotation = rotation
        let frame = CGRect(x: centre.x - diameter / 2, y: centre.y - diameter / 2, width: diameter, height: diameter)
        super.init(frame: frame)
        image = GameDisplayHelper.getPegImage(of: pegType, shape: shape)

        rotate(by: rotation)
    }

    func getRotatedAngle() -> CGFloat {
        return rotation
    }

    /// Constructs  a `PegImageView` from a `Peg`
    convenience init(peg: Peg) {
        let centre = peg.centre
        let pegType = peg.pegType
        let rotation = peg.rotation
        let shape = peg.shape

        switch shape {
        case .Circle:
            let diameter = peg.physicalShape.radius * 2
            self.init(diameter: diameter, centre: centre, pegType: pegType,
                      shape: shape, rotation: rotation)
        case .Triangle:
            let diameter = peg.physicalShape.length
            self.init(diameter: diameter, centre: centre, pegType: pegType,
                      shape: shape, rotation: rotation)
        }
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
        image = GameDisplayHelper.getPegImage(of: pegType, shape: pegShape)
    }

    /// Changes the image of a `PegImageView` to a lighted one
    func lightUp() {
        self.image = GameDisplayHelper.getLightedPegImage(of: pegType, shape: pegShape)
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

    func resize(by scale: CGFloat) {
        transform = transform.scaledBy(x: scale, y: scale)
    }

}
