//
//  TrianglePeg.swift
//  PS3
//
//  Created by Calvin Chen on 21/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import CoreGraphics

class TrianglePeg: Peg {
    let diameter: CGFloat
    let vertices: [CGPoint]

    /// Creates a peg with the given peg type and centre.
    override convenience init(withType pegType: PegType, centre: CGPoint) {
        self.init(withType: pegType, centre: centre, length: Settings.defaultTrianglePegLength)

    }

    /// Creates a peg with the given peg type, centre and a diameter.
    init(withType pegType: PegType, centre: CGPoint, length: CGFloat) {
        self.diameter = length
        let halfLength = length / 2
        let topVertex = CGPoint(x: centre.x, y: centre.y - halfLength)
        let leftVertex = CGPoint(x: centre.x - halfLength, y: centre.y + halfLength)
        let rightVertex = CGPoint(x: centre.x + halfLength, y: centre.y + halfLength)
        vertices = [topVertex, leftVertex, rightVertex]
        super.init(withType: pegType, centre: centre)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    /// Checks if the peg intersects with another peg.
    func intersects(otherPeg: CirclePeg) -> Bool {
        let otherCentre = otherPeg.getCentrePoint()
        return centre.distanceTo(other: otherCentre) < diameter
    }

    /// Checks if the peg contains a point.
    // Code adapted from https://www.geeksforgeeks.org/check-whether-a-given-point-lies-inside-a-triangle-or-not/
    override func contains(point: CGPoint) -> Bool {
        /* Calculate area of triangle ABC */
        let A = GameDisplayHelper.area(p1: vertices[0], p2: vertices[1], p3: vertices[2])

         /* Calculate area of triangle PBC */
         let A1 = GameDisplayHelper.area(p1: point, p2: vertices[1], p3: vertices[2])

         /* Calculate area of triangle PAC */
         let A2 = GameDisplayHelper.area(p1: vertices[0], p2: point, p3: vertices[2])

         /* Calculate area of triangle PAB */
         let A3 = GameDisplayHelper.area(p1: vertices[0], p2: vertices[1], p3: centre)

         /* Check if sum of A1, A2 and A3 is same as A */
         return (A == A1 + A2 + A3)
    }
}
