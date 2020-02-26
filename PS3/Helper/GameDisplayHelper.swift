//
//  Helper.swift
//  PeggleGame
//
//  Created by Calvin Chen on 26/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

/**
`GameDisplayHelper` is a class which provides helper functions related to game display.
*/
enum GameDisplayHelper {
    /// Returns an image associated with the `PegType`.
    static func getPegImage(of type: PegType, shape: PegShape) -> UIImage {
        switch shape {
        case .Circle:
            switch type {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange")
            case .green:
                return #imageLiteral(resourceName: "peg-green")
            }
        case .Triangle:
            switch type {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue-triangle")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange-triangle")
            case .green:
                return #imageLiteral(resourceName: "peg-green-triangle")
            }
        }

    }

    /// Returns an image associated with the `PegType`.
    static func getLightedPegImage(of type: PegType, shape: PegShape) -> UIImage? {
        switch shape {
        case .Circle:
            switch type {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue-glow")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange-glow")
            case .green:
                return #imageLiteral(resourceName: "peg-green-glow")
            }
        case .Triangle:
            switch type {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue-glow-triangle")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange-glow-triangle")
            case .green:
                return #imageLiteral(resourceName: "peg-green-glow-triangle")
            }
        }
    }

    /// Returns initial velocity of a ball given an angle.
    static func getInitialVelocity(angle: CGFloat) -> CGVector {
        let dX = Settings.initialVelocityForBall * cos(angle)
        let dY = Settings.initialVelocityForBall * sin(angle)
        return CGVector(dx: dX, dy: dY)
    }

    /// Returns the angle of one point from another point.
    static func getAngle(of point: CGPoint, from otherPoint: CGPoint) -> CGFloat {
        let deltaX = point.x - otherPoint.x
        let deltaY = point.y - otherPoint.y
        return atan2(deltaY, deltaX)
    }

    static func showWinAlert(in controller: UIViewController) {
        Alert.presentAlert(controller: controller, title: "Level Cleared!", message: "You win!!!")
    }

    static func showLoseAlert(in controller: UIViewController) {
        Alert.presentAlert(controller: controller, title: "Game Over!", message: "You lose. Try again next time!")
    }

    static func pointCircle(point: CGPoint, centre: CGPoint, radius: CGFloat) -> Bool {
        return centre.distanceTo(other: point) < radius
    }

    // Code adapted from http://www.jeffreythompson.org/collision-detection/line-circle.php
    static func linePoint(x1: CGFloat, y1: CGFloat, x2: CGFloat,
                          y2: CGFloat, px: CGFloat, py: CGFloat) -> Bool {
        let point = CGPoint(x: px, y: py)
        let p1 = CGPoint(x: x1, y: y1)
        let p2 = CGPoint(x: x2, y: y2)
      // get distance from the point to the two ends of the line
        let d1 = point.distanceTo(other: p1)
        let d2 = point.distanceTo(other: p2)

      // get the length of the line
        let lineLen = p1.distanceTo(other: p2)

      // since floats are so minutely accurate, add
      // a little buffer zone that will give collision
        let buffer = CGFloat(0.01);    // higher # = less accurate

      // if the two distances are equal to the line's
      // length, the point is on the line!
      // note we use the buffer here to give a range,
      // rather than one #
      if (d1 + d2 >= lineLen - buffer && d1 + d2 <= lineLen+buffer) {
        return true
      }
      return false
    }

    // Code adapted from http://www.jeffreythompson.org/collision-detection/line-circle.php
    static func lineCircle(p1: CGPoint, p2: CGPoint, centre: CGPoint, radius: CGFloat) -> Bool {

        let x1 = p1.x
        let y1 = p1.y
        let x2 = p2.x
        let y2 = p2.y
        let cx = centre.x
        let cy = centre.y
        let r = radius
        // is either end INSIDE the circle?
        // if so, return true immediately
        let inside1 = pointCircle(point: p1, centre: centre, radius: radius)
        let inside2 = pointCircle(point: p2, centre: centre, radius: radius)
        if inside1 || inside2 {
            return true
        }

        // get length of the line
        var distX = x1 - x2
        var distY = y1 - y2
        let len = sqrt( (distX * distX) + (distY * distY) )

        // get dot product of the line and circle
        let dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / (len * len)

        // find the closest point on the line
        let closestX = x1 + (dot * (x2-x1))
        let closestY = y1 + (dot * (y2-y1))

        // is this point actually on the line segment?
        // if so keep going, but if not, return false
        let onSegment = linePoint(x1: x1,y1: y1,x2: x2,y2: y2, px: closestX,py: closestY)
        if !onSegment {
            return false
        }
        // get distance to closest point
        distX = closestX - cx
        distY = closestY - cy
        let distance = sqrt( (distX*distX) + (distY*distY) )

        if distance <= r {
            return true
        }
        return false
    }

    static func getClosestEdge(centre: CGPoint, radius: CGFloat, vertices: [CGPoint]) -> (CGPoint, CGPoint)? {
        for i in 0..<vertices.count {
            let pointA = vertices[i]
            let pointB = vertices[(i + 1) % vertices.count]
            if lineCircle(p1: pointA, p2: pointB, centre: centre, radius: radius) {
                return (pointA, pointB)
            }
        }
        return nil
    }

    static func reverseVelocity(_ velocity: CGVector) -> CGVector {
        return CGVector(dx: -velocity.dx, dy: -velocity.dy)
    }
    
}
