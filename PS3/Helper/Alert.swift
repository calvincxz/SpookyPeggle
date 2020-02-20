//
//  Alert.swift
//  PS2
//
//  Created by Calvin Chen on 26/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import UIKit

/**
The `Alert` class contains functions related to creating and presenting`UIAlert`
 in the `LevelDesignerController`, mostly related to saving/loading `GameLevel`s.
*/
enum Alert {
    /// A cancel action that can be added to an `UIAlertController`
    static let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

    /// Presents an alert in an `UIViewController`.
    static func presentAlert(controller: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true)
    }
}
