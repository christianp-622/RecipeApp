//
//  CacheFileStorageTests.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/8/25.
//

import XCTest
@testable import RecipeApp

private enum Constants {
    static let folderName = "test_recipe_images"
}

final class CacheFileStorageTests: XCTestCase {
    
    private var fileManagerMock: MockFileManager!
    private var folderName: String!
    
    // System under test
    private var cacheFileStorage: CacheFileStorage!

    override func setUp() {
        super.setUp()
        fileManagerMock = MockFileManager()
        folderName = Constants.folderName
        cacheFileStorage = CacheFileStorage(
            fileManager: fileManagerMock,
            folderName: folderName
        )
    }

    override func tearDown() {
        fileManagerMock = nil
        folderName = nil
        cacheFileStorage = nil
        super.tearDown()
    }

    func test_saveImageToDisk_successfulWrite() throws {
        // GIVEN
        let key = "testKey"
        let image = try XCTUnwrap(UIImage(systemName: "star"))
        
        // WHEN
        XCTAssertNoThrow(try cacheFileStorage.saveImageToDisk(image, forKey: key))
        
        // THEN
        XCTAssertTrue(
            fileManagerMock.verifyFileWritten(
                forKey: key,
                withImage: image,
                folderName: folderName
            )
        )
    }
    
    func test_saveImageToDisk_failedToWrite() throws {
        // GIVEN
        let key = "testKey"
        let image = try XCTUnwrap(UIImage(systemName: "star"))
        
        // Set the flag for thowingErrorOnWrite to true
        fileManagerMock.shouldThrowOnWrite = true
        
        // WHEN
        XCTAssertThrowsError(
            try cacheFileStorage.saveImageToDisk(image, forKey: key)
        ) { error in
            // THEN
            let errorDescription = error.localizedDescription
            let expectedErrorDescription = FileManagerError.fileSaveFailed(GenericError.failed).localizedDescription
            
            XCTAssertEqual(errorDescription, expectedErrorDescription)
        }
    }
    
    func test_loadImageFromDisk_fileExists() throws {
        // GIVEN
        let key = "testKey"
        let image = try XCTUnwrap(UIImage(systemName: "star"))
        
        XCTAssertNoThrow(try cacheFileStorage.saveImageToDisk(image, forKey: key))
        
        // WHEN
        XCTAssertNoThrow(
            try XCTUnwrap(
                cacheFileStorage.loadImageFromDisk(forKey: key)
            )
        )
        
        // THEN
        XCTAssertTrue(
            fileManagerMock.verifyFileWritten(
                forKey: key,
                withImage: image,
                folderName: folderName
            )
        )
    }
    
    func test_loadImageFromDisk_fileDoesNotExist() throws {
        // GIVEN
        let key = "testKey"
        
        // Set flag for throwing error on read
        fileManagerMock.shouldThrowOnRead = true
        
        // WHEN
        XCTAssertThrowsError(
            try cacheFileStorage.loadImageFromDisk(forKey: key)
        ) {error in
            // THEN
            let errorDescription = error.localizedDescription
            let expectedErrorDescription = FileManagerError.fileReadFailed.localizedDescription
            XCTAssertEqual(errorDescription, expectedErrorDescription)
        }
    }
    
    func test_clearDiskCache_success() throws {
        // GIVEN
        let key = "testKey"
        let image = try XCTUnwrap(UIImage(systemName: "star"))
        
        // Preconditions
        XCTAssertNoThrow(try cacheFileStorage.saveImageToDisk(image, forKey: key))
        XCTAssertNoThrow(try cacheFileStorage.loadImageFromDisk(forKey: key))
        
        // WHEN
        XCTAssertNoThrow(try cacheFileStorage.clearDiskCache())
        
        // THEN
        XCTAssertTrue(fileManagerMock.verifyDiskCacheCleared())
    }
    
    func test_clearDiskCache_throwsFilesInDirectoryError() throws {
        // GIVEN
        let key = "testKey"
        let image = try XCTUnwrap(UIImage(systemName: "star"))
        
        // Set flag for throwing error on contentsOfDirectory
        fileManagerMock.shouldThrowOnContentsOfDirectory = true
        
        // Preconditions
        XCTAssertNoThrow(try cacheFileStorage.saveImageToDisk(image, forKey: key))
        XCTAssertNoThrow(try cacheFileStorage.loadImageFromDisk(forKey: key))
        
        // WHEN
        XCTAssertThrowsError(
            try cacheFileStorage.clearDiskCache()
        ) { error in
            // THEN
            let errorDescription = error.localizedDescription
            let expectedErrorDescription = FileManagerError.retrieveFilesInDirectoryFailed(GenericError.failed).localizedDescription
            XCTAssertEqual(errorDescription, expectedErrorDescription)
        }
    }
    
    func test_clearDiskCache_throwsFileDeletionFailed() throws {
        // GIVEN
        let key = "testKey"
        let image = try XCTUnwrap(UIImage(systemName: "star"))
        
        // Set flag for throwing error on contentsOfDirectory
        fileManagerMock.shouldThrowOnRemoveItem = true
        
        // Preconditions
        XCTAssertNoThrow(try cacheFileStorage.saveImageToDisk(image, forKey: key))
        XCTAssertNoThrow(try cacheFileStorage.loadImageFromDisk(forKey: key))
        
        // WHEN
        XCTAssertThrowsError(
            try cacheFileStorage.clearDiskCache()
        ) { error in
            // THEN
            let errorDescription = error.localizedDescription
            let expectedErrorDescription = FileManagerError.fileDeletionFailed(GenericError.failed).localizedDescription
            XCTAssertEqual(errorDescription, expectedErrorDescription)
        }
    }
}
