//
//  MathHelper.swift
//  PS3
//
//  Created by Calvin Chen on 23/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import CoreGraphics

enum MathHelper {



    static func roundOffFloat(float: CGFloat) -> CGFloat {
        let x = Double(float)
        let y = Double(round(1000 * x) / 1000)

        return CGFloat(y)
    }
}
