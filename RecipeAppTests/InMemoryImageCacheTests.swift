//
//  InMemoryImageCacheTests.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/6/25.
//

import XCTest
@testable import RecipeApp

final class InMemoryImageCacheTests: XCTestCase {
    
    private var cache: InMemoryImageCache!

    override func setUp() {
        super.setUp()
        cache = InMemoryImageCache()
    }

    override func tearDown() {
        cache = nil
        super.tearDown()
    }

    func test_addImage_andGetWithValidKey() throws {
        // GIVEN
        let key = "imageKey"
        let expectedImage = try XCTUnwrap(UIImage(systemName: "star"))
        
        cache.addImage(forKey: key, value: expectedImage)
        
        // WHEN
        let resultImage = cache.getImage(forKey: key)
        
        // THEN
        XCTAssertEqual(resultImage, expectedImage)
    }
    
    func test_addImage_andGetWithInvalidKey() throws {
        // GIVEN
        let key1 = "imageKey"
        let key2 = "wrongKey"
        let expectedImage = try XCTUnwrap(UIImage(systemName: "star"))
        cache.addImage(forKey: key1, value: expectedImage)
        
        // WHEN
        let resultImage = cache.getImage(forKey: key2)
        
        // THEN
        XCTAssertNil(resultImage)
    }
    
    func test_clearCache() throws {
        // GIVEN
        let key = "imageKey"
        let image = try XCTUnwrap(UIImage(systemName: "star"))
        cache.addImage(forKey: key, value: image)
        
        // WHEN
        cache.clearCache()
        let resultImage = cache.getImage(forKey: key)
        
        // THEN
        XCTAssertNil(resultImage)
    }
    
    func test_evictsObject_whenPastCacheLimit() throws {
        // GIVEN
        let cache = InMemoryImageCache(countLimit: 2)
        let imagePairs: [String: UIImage] = [
            "imageKey1": try XCTUnwrap(UIImage(systemName: "star")),
            "imageKey2": try XCTUnwrap(UIImage(systemName: "heart.fill")),
            "imageKey3": try XCTUnwrap(UIImage(systemName: "person"))
        ]

        // WHEN
        imagePairs.forEach { key, image in
            cache.addImage(forKey: key, value: image)
        }

        // Account for non-deterministic nature of NSCache
        let nonNilCount = imagePairs.keys
            .filter { cache.getImage(forKey: $0) != nil }.count
        
        // THEN
        XCTAssertEqual(nonNilCount, 2)
    }
}
