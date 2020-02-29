//
//  LevelPreviewCollectionViewCell.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 25/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import UIKit

class LevelPreviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!

    func setImage(_ image: UIImage) {
        imageView.image = image
    }

    func setTitle(_ text: String) {
        textLabel.text = text
    }
}
