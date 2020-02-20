//
//  BucketView.swift
//  PS3
//
//  Created by Calvin Chen on 20/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import UIKit

class BucketView: UIImageView {

    /// Moves the center of a `BallView`.
    func moveTo(point: CGPoint) {
        self.center = point
    }

    func hide() {
        alpha = 0
    }

    func show() {
        alpha = 1
    }
}
