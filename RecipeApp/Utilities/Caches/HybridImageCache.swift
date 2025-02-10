//
//  HybridImageCache.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/6/25.
//

import Foundation
import SwiftUI


class HybridImageCache {
    // Shared Instance
    static let shared = HybridImageCache()
    
    private let inMemoryCache: ImageCacheProtocol // Quick Access
    private let onDiskCache: ImageCacheProtocol  // Persistent
    
    init(
        inMemoryCache: ImageCacheProtocol = InMemoryImageCache.shared,
        onDiskCache: ImageCacheProtocol = OnDiskImageCache.shared
    ) {
        self.inMemoryCache = inMemoryCache
        self.onDiskCache = onDiskCache
    }
}

// MARK: - ImageCacheProtocol
extension HybridImageCache: ImageCacheProtocol {
    func addImage(forKey key: String, value: UIImage) {
        inMemoryCache.addImage(forKey: key, value: value)
        onDiskCache.addImage(forKey: key, value: value)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        // Check quick access cache
        if let cachedImage = inMemoryCache.getImage(forKey: key) {
            return cachedImage
        }
        
        // Check disk
        if let diskImage = onDiskCache.getImage(forKey: key) {
            inMemoryCache.addImage(forKey: key, value: diskImage)
            return diskImage
        }
        
        return nil
    }
    
    func clearCache() {
        inMemoryCache.clearCache()
        onDiskCache.clearCache()
    }
}
