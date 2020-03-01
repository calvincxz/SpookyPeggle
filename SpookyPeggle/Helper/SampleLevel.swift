//
//  SampleLevel.swift
//  PS3
//
//  Created by Calvin Chen on 3/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import UIKit

/**
`SampleLevel` provides some basic `GameLevel`s for gameplay.
*/
enum SampleLevel {
    static func getSampleLevel(view: UIView) -> GameLevel {
        let level = GameLevel()
        let widthInterval = view.bounds.width / 11
        let heightInterval = view.bounds.height / 11

        for j in [3, 5, 7, 9] {
            if j == 3 {
                for i in [5, 7] {
                    let centre = CGPoint(x: CGFloat(i) * widthInterval, y: CGFloat(j) * heightInterval)
                    let peg = Peg(type: PegType.green, triangleOfCentre: centre)
                    level.addToLevel(addedPeg: peg)
                }

            } else if j == 5 {
                for i in [3, 5, 7] {
                    let centre = CGPoint(x: CGFloat(i) * widthInterval, y: CGFloat(j) * heightInterval)
                    let peg = Peg(type: PegType.orange, circleOfCentre: centre)
                    level.addToLevel(addedPeg: peg)
                }

            } else if j == 7 || j == 9 {
                for i in [1, 3, 5, 7, 9] {
                    let centre = CGPoint(x: CGFloat(i) * widthInterval, y: CGFloat(j) * heightInterval)
                    let peg = Peg(type: PegType.blue, circleOfCentre: centre)
                    level.addToLevel(addedPeg: peg)
                }
            }
        }
        return level
    }

    static func getSampleLevelTwo(view: UIView) -> GameLevel {
        let level = GameLevel()
        let widthInterval = view.bounds.width / 12
        let heightInterval = view.bounds.height / 12

        for i in [3, 5, 7, 9] {
            for j in [3, 5, 7, 9] {
                let centre = CGPoint(x: CGFloat(i) * widthInterval, y: CGFloat(j) * heightInterval)
                let peg = Peg(type: PegType.blue, circleOfCentre: centre)
                level.addToLevel(addedPeg: peg)
            }
        }

        for i in [2, 4, 6, 8] {
            for j in [4, 6, 8] {
                let centre = CGPoint(x: CGFloat(i) * widthInterval, y: CGFloat(j) * heightInterval)
                if j == 4 {
                    let peg = Peg(type: PegType.orange, circleOfCentre: centre)
                    level.addToLevel(addedPeg: peg)
                } else {
                    let peg = Peg(type: PegType.purple, circleOfCentre: centre)
                    level.addToLevel(addedPeg: peg)
                }
            }
        }

        return level
    }

}
