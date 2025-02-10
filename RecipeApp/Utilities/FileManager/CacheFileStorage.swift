//
//  CacheFileManager.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/7/25.
//

import Foundation
import SwiftUI

private enum Constants {
    static let folderName = "downloaded_recipe_images"
    static let compressionQuality = 0.8
    static let jpgExtension = ".jpg"
}

class CacheFileStorage {
    private let fileManager: FileManagerProtocol
    private let folderName: String
    
    init(
        fileManager: FileManagerProtocol = FileManager.default,
        folderName: String = Constants.folderName
    ) {
        self.fileManager = fileManager
        self.folderName = folderName
        
        // Ensure the cache folder is created when the this is initialized.
        try? createCacheFolderIfNeeded()
    }
}

// MARK: - CacheFileStorageProtocol
extension CacheFileStorage: CacheFileStorageProtocol{
    func saveImageToDisk(_ image: UIImage, forKey key: String) throws {
        guard let data = image.jpegData(compressionQuality: Constants.compressionQuality),
              let filePath = getImagePath(forKey: key)
        else { return }
        
        do {
            try fileManager.write(data: data, to: filePath)
            //print("✅ Image saved to disk: \(filePath.path)")
        } catch {
            throw FileManagerError.fileSaveFailed(error)
        }
    }
    
    func loadImageFromDisk(forKey key: String) throws -> UIImage? {
        guard let filePath = getImagePath(forKey: key) else { return nil }
        
        do {
            let data = try fileManager.read(from: filePath)
            return UIImage(data: data)
        } catch {
            throw FileManagerError.fileReadFailed
        }
    }
    
    // Note: We do not delete the directory in this instance. Just the files created
    func clearDiskCache() throws {
        guard let folderPath = getFolderPath() else { return }

        var throwsRemoveItemError = false
        
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: folderPath.path)
            for file in filePaths {
                let fileURL = folderPath.appendingPathComponent(file)
                do {
                    try fileManager.removeItem(at: fileURL)
                } catch {
                    throwsRemoveItemError = true
                    throw error
                }
            }
        } catch {
            if throwsRemoveItemError {
                throw FileManagerError.fileDeletionFailed(error)
            } else {
                throw FileManagerError.retrieveFilesInDirectoryFailed(error)
            }
        }
    }
}

// MARK: - Helpers
private extension CacheFileStorage {
    func getFolderPath() -> URL? {
        return fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    func createCacheFolderIfNeeded() throws {
        guard let url = getFolderPath() else { return }
        
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw FileManagerError.directoryCreationFailed(error)
            }
        }
    }
    
    func getImagePath(forKey key: String) -> URL? {
        return getFolderPath()?.appendingPathComponent(key + Constants.jpgExtension)
    }
}
