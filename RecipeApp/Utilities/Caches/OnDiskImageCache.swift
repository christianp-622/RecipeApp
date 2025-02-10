//
//  OnDiskImageCache.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/7/25.
//

import Foundation
import SwiftUI

class OnDiskImageCache {
    // Shared Instance
    static let shared = OnDiskImageCache()
    
    private let cacheFileStorage: CacheFileStorageProtocol
    
    init(fileStorage: CacheFileStorageProtocol = CacheFileStorage()) {
        self.cacheFileStorage = fileStorage
    }
}

// MARK: - ImageCacheProtocol
extension OnDiskImageCache: ImageCacheProtocol {
    func addImage(forKey key: String, value: UIImage) {
        try? cacheFileStorage.saveImageToDisk(value, forKey: key)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return try? cacheFileStorage.loadImageFromDisk(forKey: key)
    }
    
    func clearCache() {
        try? cacheFileStorage.clearDiskCache()
    }
}
