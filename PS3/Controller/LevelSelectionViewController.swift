//
//  LevelSelectionCollectionViewController.swift
//  PS3
//
//  Created by Calvin Chen on 25/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
private let itemsPerRow: CGFloat = 3

class LevelSelectionViewController: UIViewController {

    @IBOutlet private weak var levelCollectionView: UICollectionView!
    private var levelName = "Untitled"
    private var gameLevel: GameLevel?
    private let levelPreviewStorage = LevelPreviewStorage()
    var previousScreen: GameScreenType?
    
    override func viewDidLoad() {
        levelCollectionView.delegate = self
        levelCollectionView.dataSource = self
        super.viewDidLoad()

    }

    @IBAction private func backToMenu() {
        dismiss(animated: false, completion: nil)
    }
}

extension LevelSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelPreviewStorage.levelCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = getReusableCell(for: indexPath)

        guard let image = levelPreviewStorage.getImage(at: indexPath.row, size: cell.frame.size) else {
            return cell
        }
        let fileName = levelPreviewStorage.getFileName(at: indexPath.row)
        levelName = fileName

        cell.imageView.image = image
        cell.textLabel.text = fileName

        return cell
    }

    private func getReusableCell(for indexPath: IndexPath) -> LevelPreviewCollectionViewCell {
        guard let cell = levelCollectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier, for: indexPath) as? LevelPreviewCollectionViewCell else {
                fatalError("Unable to get reusable cell.")
        }
        return cell
    }
}

// Code for layout adapted from https://www.raywenderlich.com/9334-uicollectionview-tutorial-getting-started
extension LevelSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
    }
}

/// Gestures
extension LevelSelectionViewController {

    /// Loads a level when single tap is detected on a specific cell.
    @IBAction private func handleSingleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: levelCollectionView)
        guard let indexPath = levelCollectionView.indexPathForItem(at: location) else {
            return
        }
        loadGameLevel(at: indexPath.row)
    }

    /// Deletes the level when long press is detected on a specific cell.
    @IBAction func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: levelCollectionView)
        guard let indexPath = levelCollectionView.indexPathForItem(at: location),
            indexPath.row != levelPreviewStorage.levelCount else {
            return
        }
        Alert.presentDeleteAlert(controller: self, index: indexPath.row)
    }

    private func loadGameLevel(at index: Int) {
        guard let gameLevel = levelPreviewStorage.getData(at: index) else {
            fatalError("No game")
        }

        guard let previous = previousScreen else {
            return
        }
        self.gameLevel = gameLevel
        self.levelName = levelPreviewStorage.getFileName(at: index)

        switch previous {
        case .Home:
            performSegue(withIdentifier: "selectionToGame", sender: self)
        case .LevelDesign:
            performSegue(withIdentifier: "selectionToLevelDesign", sender: self)
        default:
            return
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GamePlayController {
            let target = segue.destination as? GamePlayController
            target?.gameLevel = gameLevel
        }

        if segue.destination is LevelDesignerController {
            let target = segue.destination as? LevelDesignerController
            guard let level = gameLevel else {
                return
            }
            target?.gameLevel = level
            target?.currentLevelName = levelName
        }
    }


    func deleteLevel(at index: Int) {
        guard levelPreviewStorage.deleteLevel(at: index) else {
            Alert.presentAlert(controller: self, title: "Delete Fail", message: "Unable to delete game level!")
            return
        }
        levelCollectionView.reloadData()
    }

}
