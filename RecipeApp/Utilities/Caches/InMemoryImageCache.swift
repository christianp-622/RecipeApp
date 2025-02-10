//
//  InMemoryImageCache.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/6/25.
//

import Foundation
import SwiftUI

private enum Constants {
    static let countLimit = 100
}

class InMemoryImageCache {
    // Shared Instance
    static let shared = InMemoryImageCache()
    
    private let cache: NSCache<NSString, UIImage>
    
    init(countLimit: Int = Constants.countLimit) {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = countLimit
        self.cache = cache
    }
}

// MARK: - ImageCacheProtocol
extension InMemoryImageCache: ImageCacheProtocol {
    func addImage(forKey key: String, value: UIImage) {
        cache.setObject(value, forKey: key as NSString)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
