//
//  CGPoint + Hashable.swift
//  PS2
//
//  Created by Calvin Chen on 25/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//
import Foundation
import CoreGraphics

extension CGPoint: Hashable {
    func distanceTo(other: CGPoint) -> CGFloat {
        let distanceX = (self.x - other.x)
        let distanceY = (self.y - other.y)
        return sqrt((distanceX * distanceX) + (distanceY * distanceY))
    }

    static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        return lhs.x == rhs.x
            &&  lhs.y == rhs.y
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
