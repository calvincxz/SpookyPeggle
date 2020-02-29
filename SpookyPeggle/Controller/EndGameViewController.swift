//
//  EndGameViewController.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 29/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    var isGameWon: Bool?

    @IBOutlet private weak var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMessage()
    }

    private func initializeMessage() {
        guard let win = isGameWon else {
            return
        }
        if win {
            textLabel.text = "victory"
        } else {
            textLabel.text = "Defeat"
        }
    }

    @IBAction private func backToMainMenu(_ sender: UIButton) {
        performSegue(withIdentifier: "endToMenu", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
