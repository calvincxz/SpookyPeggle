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

    // Solution adapted from https://stackoverflow.com/questions/35683376/rotating-a-cgpoint-around-another-cgpoint
    func rotate(origin: CGPoint, byRadians: CGFloat) -> CGPoint {
        guard byRadians != CGFloat.zero else {
            return self
        }

        let dx = x - origin.x
        let dy = y - origin.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) 
        let newAzimuth = azimuth + byRadians
        let x = origin.x + radius * cos(newAzimuth)
        let y = origin.y + radius * sin(newAzimuth)
        return CGPoint(x: x, y: y)
    }

    func moveTo(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
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
