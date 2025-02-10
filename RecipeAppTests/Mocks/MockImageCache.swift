//
//  MockImageCache.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/7/25.
//

import Foundation
import SwiftUI
@testable import RecipeApp


class MockImageCache: ImageCacheProtocol {
    private var imageCache: [String: UIImage] = [:]
    private var didCallGetImage = false

    func addImage(forKey key: String, value: UIImage) {
        imageCache[key] = value
    }

    func getImage(forKey key: String) -> UIImage? {
        didCallGetImage = true
        return imageCache[key]
    }

    func clearCache() {
        imageCache.removeAll()
    }
}

// MARK: - Verification 
extension MockImageCache {
    func verifyImageWasAdded(
        for key: String,
        and value: UIImage
    ) -> Bool {
        guard let storedImage = imageCache[key] else {
            return false
        }
        
        guard let expectedData = value.pngData(),
              let storedData = storedImage.pngData() else {
            return false
        }
        
        return expectedData == storedData
    }
    
    func verifyGetImageCalled() -> Bool {
        return didCallGetImage
    }
    
    func verifyClearCacheWasCalled() -> Bool {
        return imageCache.isEmpty
    }
}
