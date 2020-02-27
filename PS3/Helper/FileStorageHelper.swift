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
        let fileURL = FileStorageHelper.getFileURL(from: fileName, with: "json")
        guard (try? JSONEncoder().encode(gameLevel).write(to: fileURL)) != nil else {
            return false
        }
        return true
    }

    /// Loads a `GameLevel` from a file name in the document directory.
    /// - Returns: a `GameLevel` object
    /// If there is an error in the decoding process, returns nil.
    static func loadDataFromFile(withName fileName: String) -> GameLevel? {
        let fileURL = FileStorageHelper.getFileURL(from: fileName, with: "json")
        return loadDataFromURL(fileURL: fileURL)
    }

    /// Loads a `GameLevel` from a given URL
    /// - Returns: a `GameLevel` object
    /// If there is an error in the decoding process, returns nil.
    static func loadDataFromURL(fileURL: URL) -> GameLevel? {
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
    /// - Returns: a list of file names
    /// If there is an error in locating contents of document directory, returns nil.
    static func getDocumentDirectoryFileNames() -> [String]? {
        guard let jsonFiles = getDocumentDirectoryFileURLs(pathExtension: "json") else {
            return nil
        }
        let jsonFileNames = jsonFiles.map { $0.deletingPathExtension().lastPathComponent }
        return jsonFileNames
    }

    /// Gets a list of file URLs found in the document directory.
    /// - Returns: a list of URL
    /// If there is an error in the process, returns nil.
    static func getDocumentDirectoryFileURLs(pathExtension: String) -> [URL]? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        guard let directoryContents = try? FileManager.default.contentsOfDirectory(
            at: directory, includingPropertiesForKeys: nil) else {
            return nil
        }
        return directoryContents.filter { $0.pathExtension == pathExtension }
    }

    static func deleteFile(filePath: URL) -> Bool {
        return ((try? FileManager.default.removeItem(at: filePath)) != nil)
    }

    /// Checks whether the pre-loaded levels have been loaded before.
    /// Failure to
    static func preloadLevels() {
        Settings.preloadedLevelNames.forEach { loadData($0) }
    }

    /// Loads the data from a certain file name into the document directory.
    /// - Parameter fileName: The file name of loaded data.
    static func loadData(_ fileName: String) -> Bool {
        /// The URL we copy data from.
        guard let from = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            return false
        }
        /// The URL we will copy data to.
        var to = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        to.appendPathComponent(fileName)

        /// Copies the item over.
        guard (try? FileManager.default.copyItem(at: from, to: to)) != nil else {
            return false
        }
        return true

    }
}
