//
//  GameObject.swift
//  PS3
//
//  Created by Calvin Chen on 3/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//
import CoreGraphics

/**
The `GameObject` extends the `PhysicsBody` and represents objects specific to the Peggle Game.
*/
class GameObject: PhysicsBody, Hashable {

    /// Defines the equality of`GameObject`s.
    /// Two `GameObject` cannot have the same centre
    static func == (lhs: GameObject, rhs: GameObject) -> Bool {
        lhs.centre == rhs.centre &&
        lhs.radius == rhs.radius
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(centre)
        hasher.combine(radius)
    }

}
