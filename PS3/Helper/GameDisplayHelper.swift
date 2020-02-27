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

    static func getGameMasterImage(master: GameMaster) -> UIImage {
        switch master {
        case .Pumpkin:
            return #imageLiteral(resourceName: "Pumpkin")
        case .Bat:
            return #imageLiteral(resourceName: "Bat")
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

    

    

    static func reverseVelocity(_ velocity: CGVector) -> CGVector {
        return CGVector(dx: -velocity.dx, dy: -velocity.dy)
    }
    
}
