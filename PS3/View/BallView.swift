//
//  BallView.swift
//  PS3
//
//  Created by Calvin Chen on 11/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

/**
The `BallView` is an `UIImageView` which represents the ball
 that the user sees on the screen.
*/
class BallView: UIImageView {

    init(diameter: CGFloat, centre: CGPoint) {
        let frame = CGRect(x: centre.x - diameter / 2, y: centre.y - diameter / 2, width: diameter, height: diameter)
        super.init(frame: frame)
        self.image = #imageLiteral(resourceName: "ball")
    }

    convenience init(centre: CGPoint) {
        self.init(diameter: Settings.defaultBallDiameter, centre: centre)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Moves the center of a `BallView`.
    func moveTo(point: CGPoint) {
        self.center = point
    }
}
