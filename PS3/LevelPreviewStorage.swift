//
//  LevelPreviewStorage.swift
//  PS3
//
//  Created by Calvin Chen on 26/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import UIKit

// Contains image and data url
class LevelPreviewStorage {
    private var imageURLs = [URL]()
    private var dataURLs = [URL]()

    init() {
        imageURLs = FileStorageHelper.getDocumentDirectoryFileURLs(pathExtension: "png") ?? []
        dataURLs = imageURLs.map { $0.deletingPathExtension().appendingPathExtension("json")
        }
    }

    /// Gets the screenshot image path to the level at a specific index.
    /// - Parameter index: The index of the intended level (zero-based).
    /// - Returns: The URL to the screenshot image.
    func getImage(at index: Int, size: CGSize) -> UIImage? {
        //let size = CGSize(width: size.width, height: size.height * CGFloat(0.5))
        guard let levelImage = UIImage(contentsOfFile: imageURLs[index].path) else {
            return nil
        }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            levelImage.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    func getFileName(at index: Int) -> String {
        let URL = dataURLs[index]
        return URL.deletingPathExtension().lastPathComponent
    }

    func getData(at index: Int) -> GameLevel? {
        let URL = dataURLs[index]
        return FileStorageHelper.loadDataFromURL(fileURL: URL)
    }

    /// Deletes the level at a specific index; does nothing if there is no
    /// level at the specified index.
    /// - Parameter index: The index of the intended level (zero-based).
    func deleteLevel(at index: Int) -> Bool {
        guard index >= 0 && index < levelCount else {
            return false
        }

        let imagePath = imageURLs[index]
        let dataPath = dataURLs[index]
//
//        try FileManager.default.removeItem(at: imagePath)
//
//        try FileManager.default.removeItem(at: dataPath)
        guard FileStorageHelper.deleteFile(filePath: imagePath) && FileStorageHelper.deleteFile(filePath: dataPath) else {
            return false
        }

        imageURLs.remove(at: index)
        dataURLs.remove(at: index)
        return true
    }

    /// Counts the number of levels that have been saved previously.
    /// - Returns: the number of levels.
    var levelCount: Int {
        return imageURLs.count
    }
}
