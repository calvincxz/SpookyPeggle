//
//  HomeViewController.swift
//  PS3
//
//  Created by Calvin Chen on 20/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func goToPlay(_ sender: UIButton) {
        performSegue(withIdentifier: "homeToPlay", sender: self)
    }

    @IBAction private func goToLevelDesign(_ sender: UIButton) {
        performSegue(withIdentifier: "homeToLevelDesign", sender: self)
    }

    @IBAction private func goToSelect(_ sender: UIButton) {
        performSegue(withIdentifier: "select", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LevelSelectionViewController {
            //segue.
            let target = segue.destination as? LevelSelectionViewController
            target?.previousScreen = .Home
        }

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
