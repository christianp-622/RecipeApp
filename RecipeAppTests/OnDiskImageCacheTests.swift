//
//  OnDiskImageCacheTests.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/7/25.
//

import XCTest
@testable import RecipeApp

final class OnDiskImageCacheTests: XCTestCase {
    
    private var cacheFileStorageMock: MockCacheFileStorage!
    
    // System under test
    private var onDiskImageCache: OnDiskImageCache!

    override func setUp() {
        super.setUp()
        cacheFileStorageMock = MockCacheFileStorage()
        onDiskImageCache = OnDiskImageCache(
            fileStorage: cacheFileStorageMock
        )
    }

    override func tearDown()  {
        cacheFileStorageMock = nil
        onDiskImageCache = nil
        super.tearDown()
    }

    func test_addImage() throws {
        // GIVEN
        let key = "testKey"
        let image = try XCTUnwrap(UIImage(systemName: "star"))

        // WHEN
        onDiskImageCache.addImage(forKey: key, value: image)
        
        // THEN
        XCTAssertTrue(cacheFileStorageMock.verifyImageWasAdded(for: key, and: image))
    }
    
    func test_getImage() throws {
        // GIVEN
        let key = "testKey"
        let expectedImage = try XCTUnwrap(UIImage(systemName: "star"))
        
        onDiskImageCache.addImage(forKey: key, value: expectedImage)
        
        // WHEN
        let resultImage = try XCTUnwrap(onDiskImageCache.getImage(forKey: key))
        
        // THEN
        XCTAssertEqual(resultImage.pngData(), expectedImage.pngData())
    }
    
    func test_clearCache() throws {
        // GIVEN
        let imagePairs: [String: UIImage] = [
            "imageKey1": try XCTUnwrap(UIImage(systemName: "star")),
            "imageKey2": try XCTUnwrap(UIImage(systemName: "heart.fill")),
            "imageKey3": try XCTUnwrap(UIImage(systemName: "person"))
        ]
        
        imagePairs.forEach { key, image in
            onDiskImageCache.addImage(forKey: key, value: image)
        }
        
        // WHEN
        onDiskImageCache.clearCache()
        
        // THEN
        XCTAssertTrue(cacheFileStorageMock.verifyClearCacheWasCalled())
    }

}
