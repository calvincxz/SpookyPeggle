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

    var levelCount: Int {
        return imageURLs.count
    }

    init() {
        FileStorageHelper.preloadLevels()
        imageURLs = FileStorageHelper.getDocumentDirectoryFileURLs(pathExtension: "png") ?? []
        dataURLs = imageURLs.map { $0.deletingPathExtension().appendingPathExtension("json")
        }
    }

    func getImage(at index: Int, size: CGSize) -> UIImage? {
        guard let levelImage = UIImage(contentsOfFile: imageURLs[index].path) else {
            return nil
        }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
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

    /// Deletes the level at a specific index
    func deleteLevel(at index: Int) -> Bool {
        guard index >= 0 && index < levelCount else {
            return false
        }

        let imagePath = imageURLs[index]
        let dataPath = dataURLs[index]

        guard FileStorageHelper.deleteFile(filePath: imagePath) &&
            FileStorageHelper.deleteFile(filePath: dataPath) else {
            return false
        }

        imageURLs.remove(at: index)
        dataURLs.remove(at: index)
        return true
    }

}
