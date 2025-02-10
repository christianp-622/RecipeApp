//
//  MockCacheFileStorage.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/8/25.
//

import Foundation
import SwiftUI
@testable import RecipeApp

class MockCacheFileStorage: CacheFileStorageProtocol {
    private var fileStorage: [String: UIImage] = [:]
    
    var saveImageToDiskError: Error?
    var clearDiskCacheError: Error?
    
    func saveImageToDisk(_ image: UIImage, forKey key: String) throws {
        if let error = saveImageToDiskError {
            throw error
        }
        fileStorage[key] = image
    }
    
    func loadImageFromDisk(forKey key: String) -> UIImage? {
        return fileStorage[key]
    }
    
    func clearDiskCache() throws {
        if let error = clearDiskCacheError {
            throw error
        }
        fileStorage.removeAll()
    }
}


// MARK: - Verificiation
extension MockCacheFileStorage {
    func verifyImageWasAdded(
        for key: String,
        and value: UIImage
    ) -> Bool {
        guard let storedImage = fileStorage[key] else {
            return false
        }
        
        guard let expectedData = value.pngData(),
              let storedData = storedImage.pngData() else {
            return false
        }
        
        return expectedData == storedData
    }
    
    func verifyClearCacheWasCalled() -> Bool {
        return fileStorage.isEmpty
    }
}
