//
//  HybridImageCacheTests.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/6/25.
//

import XCTest
@testable import RecipeApp

final class HybridImageCacheTests: XCTestCase {
    
    private var inMemoryCacheMock: MockImageCache!
    private var onDiskCacheMock: MockImageCache!
    
    // System under test
    private var hybridCache: HybridImageCache!

    override func setUp() {
        super.setUp()
        inMemoryCacheMock = MockImageCache()
        onDiskCacheMock = MockImageCache()
        hybridCache = HybridImageCache(
            inMemoryCache: inMemoryCacheMock,
            onDiskCache: onDiskCacheMock
        )
    }

    override func tearDown()  {
        inMemoryCacheMock = nil
        onDiskCacheMock = nil
        hybridCache = nil
        super.tearDown()
    }

    func test_addImage_delegatesToBothCaches() throws {
        // GIVEN
        let image = try XCTUnwrap(UIImage(systemName: "star"))
        let key = "imageKey"

        // WHEN
        hybridCache.addImage(forKey: key, value: image)

        // THEN
        XCTAssertTrue(inMemoryCacheMock.verifyImageWasAdded(for: key, and: image))
        XCTAssertTrue(onDiskCacheMock.verifyImageWasAdded(for: key, and: image))
    }
    
    func test_getImage_returnsImageFromInMemoryCache_ifPresent() throws {
        // GIVEN
        let image = try XCTUnwrap(UIImage(systemName: "star"))
        let key = "imageKey"

        hybridCache.addImage(forKey: key, value: image)
        
        // WHEN
        let result = try XCTUnwrap(hybridCache.getImage(forKey: key))

        // THEN
        
        // Ensure proper result
        XCTAssertEqual(result.pngData(), image.pngData())
        
        // Both caches need to have added added the image
        XCTAssertTrue(inMemoryCacheMock.verifyImageWasAdded(for: key, and: image))
        XCTAssertTrue(onDiskCacheMock.verifyImageWasAdded(for: key, and: image))
        
        // Ensure retrieved from memory
        XCTAssertTrue(inMemoryCacheMock.verifyGetImageCalled())
        XCTAssertFalse(onDiskCacheMock.verifyGetImageCalled())
    }
    
    func test_getImage_returnsImageFromOnDiskCache_ifInMemoryIsNotPresent() throws {
        // GIVEN
        let image = try XCTUnwrap(UIImage(systemName: "star"))
        let key = "imageKey"

        // Simulate persistence by only adding to disk cache
        onDiskCacheMock.addImage(forKey: key, value: image)
        
        // WHEN
        let result = try XCTUnwrap(hybridCache.getImage(forKey: key))

        // THEN
        
        // Ensure proper result
        XCTAssertEqual(result.pngData(), image.pngData())
        
        // Ensure image added inMemory cache
        XCTAssertTrue(inMemoryCacheMock.verifyImageWasAdded(for: key, and: image))
        
        // Ensure retrived from disk
        XCTAssertTrue(onDiskCacheMock.verifyGetImageCalled())
    }
    
    func test_getImage_returnsNil_ifImageNotInEitherCache() {
        // WHEN
        let result = hybridCache.getImage(forKey: "")

        // THEN
        XCTAssertNil(result)
    }
    
    func test_clearCache_clearsBothCaches() throws {
        // GIVEN
        let imagePairs: [String: UIImage] = [
            "imageKey1": try XCTUnwrap(UIImage(systemName: "star")),
            "imageKey2": try XCTUnwrap(UIImage(systemName: "heart.fill")),
            "imageKey3": try XCTUnwrap(UIImage(systemName: "person"))
        ]
        
        imagePairs.forEach { key, image in
            hybridCache.addImage(forKey: key, value: image)
        }
        
        // WHEN
        hybridCache.clearCache()
        
        // THEN
        XCTAssertTrue(inMemoryCacheMock.verifyClearCacheWasCalled())
        XCTAssertTrue(onDiskCacheMock.verifyClearCacheWasCalled())
    }
}
