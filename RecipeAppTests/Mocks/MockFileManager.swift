//
//  MockFileManager.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/8/25.
//

import Foundation
import SwiftUI
@testable import RecipeApp

private enum Constants {
    static let path = "/temp/caches"
    static let jpgExtension = ".jpg"
    static let compressionQuality = 0.8
}

class MockFileManager: FileManagerProtocol {
    // Simulate a file system with a dictionary.
    var directories: Set<String> = []
    var files: [String: Data] = [:]
    
    // Flags to simulate error conditions.
    var shouldThrowOnCreateDirectory = false
    var shouldThrowOnContentsOfDirectory = false
    var shouldThrowOnRemoveItem = false
    var shouldThrowOnWrite = false
    var shouldThrowOnRead = false
    
    func createDirectory(
        at url: URL,
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey : Any]?
    ) throws {
        if shouldThrowOnCreateDirectory {
            throw FileManagerError.directoryCreationFailed(GenericError.failed)
        }
        directories.insert(url.path)
    }

    func urls(
        for directory: FileManager.SearchPathDirectory,
        in domainMask: FileManager.SearchPathDomainMask
    ) -> [URL] {
        return [URL(fileURLWithPath: Constants.path)]
    }

    func fileExists(
        atPath path: String
    ) -> Bool {
        return files[path] != nil || directories.contains(path)
    }

    func contentsOfDirectory(
        atPath path: String
    ) throws -> [String] {
        if shouldThrowOnContentsOfDirectory {
            throw FileManagerError.retrieveFilesInDirectoryFailed(GenericError.failed)
        }
        
        return files
            .keys
            .filter { $0.hasPrefix(path) }
            .map { URL(fileURLWithPath: $0).lastPathComponent }
    }

    func removeItem(
        at url: URL
    ) throws {
        if shouldThrowOnRemoveItem {
            throw GenericError.failed
        }
        files.removeValue(forKey: url.path)
    }
    
    func write(
        data: Data,
        to url: URL
    ) throws {
        if shouldThrowOnWrite {
            throw FileManagerError.fileSaveFailed(GenericError.failed)
        }
        files[url.path] = data
    }
    
    func read(from url: URL) throws -> Data {
        if shouldThrowOnRead {
            throw FileManagerError.fileSaveFailed(GenericError.failed)
        }
        guard let data = files[url.path] else {
            throw FileManagerError.fileReadFailed
        }
        return data
    }
}

// MARK: - Verificiation
extension MockFileManager {
    func verifyFileWritten(
        forKey key: String,
        withImage image: UIImage,
        folderName: String,
        jpgExtension: String = Constants.jpgExtension
    ) -> Bool {
        let expectedFolderPath = "\(Constants.path)/\(folderName)"
        let expectedFilePath = "\(expectedFolderPath)/\(key)\(jpgExtension)"
        let result = (files[expectedFilePath] != nil) && (files[expectedFilePath] == image.jpegData(compressionQuality: Constants.compressionQuality))
        return result
    }
    
    func verifyDirectoryCreated(
        for folderName: String
    ) -> Bool {
        let expectedFolderPath = "\(Constants.path)/\(folderName)"
        return directories.contains(expectedFolderPath)
    }
    
    func verifyDiskCacheCleared() -> Bool {
        return !directories.isEmpty && files.isEmpty
    }
}
