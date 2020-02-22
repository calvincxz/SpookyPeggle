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
    static func getPegImage(of type: PegType) -> UIImage {
        switch type {
        case .blue:
            return #imageLiteral(resourceName: "peg-blue")
        case .orange:
            return #imageLiteral(resourceName: "peg-orange")
        case .erase:
            return #imageLiteral(resourceName: "delete.png")
        case .green:
            return #imageLiteral(resourceName: "peg-green-triangle")
        }
    }

    /// Returns an image associated with the `PegType`.
    static func getLightedPegImage(of type: PegType) -> UIImage? {
        switch type {
        case .blue:
            return #imageLiteral(resourceName: "peg-blue-glow")
        case .orange:
            return #imageLiteral(resourceName: "peg-orange-glow")
        case .green:
            return #imageLiteral(resourceName: "peg-green-glow-triangle")
        default:
            return nil
        }
    }

     /// Returns a reflected vector after collision.
     /// Formula adapted from https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector
     /// - Parameters:
     ///     - a: incident vector
     ///     - b: normal vector
    static func calculateReflectedVector(a: CGVector, b: CGVector) -> CGVector {
        let length = sqrt(b.dx * b.dx + b.dy * b.dy)
        let normalizedNormal = CGVector(dx: b.dx / length, dy: b.dy / length)
        let dotProduct = a.dx * normalizedNormal.dx + a.dy * normalizedNormal.dy
        let result = CGVector(dx: a.dx - 2 * dotProduct * normalizedNormal.dx,
                              dy: a.dy - 2 * dotProduct * normalizedNormal.dy)

        return result
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

    // Code adapted from https://www.geeksforgeeks.org/check-whether-a-given-point-lies-inside-a-triangle-or-not/

    static func area(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGFloat {

        let x1 = p1.x
        let y1 = p1.y
        let x2 = p2.x
        let y2 = p2.y
        let x3 = p3.x
        let y3 = p3.y
        return abs((x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2))/2.0)
    }
}
