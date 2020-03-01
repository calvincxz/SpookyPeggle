//
//  LevelPreviewStorage.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 26/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import UIKit

class LevelPreviewStorage {
    private var imageURLs = [URL]()
    private var dataURLs = [URL]()

    // Number of saved levels in storage
    var levelCount: Int {
        return imageURLs.count
    }

    /// Initializes with 3 preloaded levels.
    /// Also loads other saved levels with an accessible screenshot
    init() {
        FileStorageHelper.preloadLevels()
        imageURLs = FileStorageHelper.getDocumentDirectoryFileURLs(pathExtension: "png") ?? []
        dataURLs = imageURLs.map { $0.deletingPathExtension().appendingPathExtension("json")
        }
    }

    /// Gets the image at a specific index
    func getImage(at index: Int, size: CGSize) -> UIImage? {
        guard let levelImage = UIImage(contentsOfFile: imageURLs[index].path) else {
            return nil
        }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            levelImage.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    /// Gets the file name without extension at a specific index
    func getFileName(at index: Int) -> String {
        let URL = dataURLs[index]
        return URL.deletingPathExtension().lastPathComponent
    }

    /// Gets the decoded game level object at a specific index
    func getData(at index: Int) -> GameLevel? {
        let URL = dataURLs[index]
        return FileStorageHelper.loadDataFromURL(fileURL: URL)
    }

    /// Deletes the level at a specific index
    /// Both image and data are deleted
    func deleteLevel(at index: Int) -> Bool {
        guard index >= 0 && index < levelCount else {
            return false
        }

        let imagePath = imageURLs[index]
        let dataPath = dataURLs[index]
        let levelName = getFileName(at: index)
        guard !Settings.preloadedLevelNames.contains(levelName) else {
            return false
        }

        guard FileStorageHelper.deleteFile(filePath: imagePath) &&
            FileStorageHelper.deleteFile(filePath: dataPath) else {
            return false
        }

        imageURLs.remove(at: index)
        dataURLs.remove(at: index)
        return true
    }

}
