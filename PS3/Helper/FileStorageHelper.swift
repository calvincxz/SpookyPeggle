//
//  FileStorageHelper.swift
//  PeggleGame
//
//  Created by Calvin Chen on 27/1/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation

/// The `FileStorageHelper` contains methods which helps with loading/saving of data.
/// It also contains several helper methods related to files/directories.
class FileStorageHelper {

    /// Saves a `GameLevel` to a file in the document directory.
    /// - Returns: True if save is successful
    /// If there is an error in the saving process, returns false.
    static func saveLevelToFile(gameLevel: GameLevel, fileName: String) -> Bool {
        for peg in gameLevel.getPegsInLevel() {
            print("rotation: " + peg.getRotatedAngle().description)
        }
        let fileURL = FileStorageHelper.getFileURL(from: fileName, with: "json")
        guard let _ = try? JSONEncoder().encode(gameLevel).write(to: fileURL) else {
            return false
        }
        return true
    }

    /// Loads a `GameLevel` from a file in the document directory.
    /// - Returns: a `GameLevel` object
    /// If there is an error in the decoding process, returns nil.
    static func loadDataFromFile(withName fileName: String) -> GameLevel? {
        let fileURL = FileStorageHelper.getFileURL(from: fileName, with: "json")
        let gameLevelFromJsonData = try? JSONDecoder().decode(GameLevel.self, from: Data(contentsOf: fileURL))
        return gameLevelFromJsonData
    }

    /// Gets the URL of a file located in the document directory.
    /// - Returns: an URL of the file path of the specified file.
    static func getFileURL(from fileName: String, with fileExtension: String) -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    }

    /// Checks if a JSON file exists in the document directory
    static func checkIfFileExist(fileName: String) -> Bool {
        guard let jsonFileNames = getDocumentDirectoryFileNames() else {
            return false
        }
        return jsonFileNames.contains(fileName)
    }

    /// Gets a list of file names found in the document directory.
    /// - Returns: an array of file names
    /// If there is an error in locating contents of document directory, returns nil.
    static func getDocumentDirectoryFileNames() -> [String]? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        guard let directoryContents = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil) else {
            return nil
        }

        let jsonFiles = directoryContents.filter { $0.pathExtension == "json" }
        let jsonFileNames = jsonFiles.map { $0.deletingPathExtension().lastPathComponent }
        return jsonFileNames
    }
}
