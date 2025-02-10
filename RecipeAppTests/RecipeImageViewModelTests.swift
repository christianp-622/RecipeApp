//
//  RecipeImageViewModelTests.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/9/25.
//

import XCTest
@testable import RecipeApp

final class RecipeImageViewModelTests: XCTestCase {
    
    func test_loadImage_withValidImageURL_fromAPIService() async throws {
        // GIVEN
        let apiServiceMock = MockRecipeAPIService()
        let cacheMock = MockImageCache()
        let imageURL = try XCTUnwrap(URL(string: "https://validURL.com/superValid"))
        let imageId = "1234"
        
        let viewModel = RecipeImageViewModel(
            apiService: apiServiceMock,
            cache: cacheMock,
            imageURL: imageURL,
            imageId: imageId
        )
        
        // Simulate returned image
        let expectedImage = try XCTUnwrap(UIImage(systemName: "star"))
        apiServiceMock.imageToReturn = expectedImage
        
        // WHEN
        await viewModel.loadImage()
        
        // THEN
        XCTAssertTrue(apiServiceMock.verifyDidCallFetchImage())
        XCTAssertTrue(cacheMock.verifyImageWasAdded(for: imageId, and: expectedImage))
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_loadImage_withValidImageURL_butFetchfrom_cache() async throws {
        // GIVEN
        let apiServiceMock = MockRecipeAPIService()
        let cacheMock = MockImageCache()
        let imageURL = try XCTUnwrap(URL(string: "https://validURL.com/superValid"))
        let imageId = "1234"
        
        let viewModel = RecipeImageViewModel(
            apiService: apiServiceMock,
            cache: cacheMock,
            imageURL: imageURL,
            imageId: imageId
        )
        
        // Simulate item already cached
        let expectedImage = try XCTUnwrap(UIImage(systemName: "star"))
        apiServiceMock.imageToReturn = expectedImage
        cacheMock.addImage(forKey: imageId, value: expectedImage)
        
        // WHEN
        await viewModel.loadImage()
        
        // THEN
        
        // Verify we only got image from cache and not api service
        XCTAssertTrue(cacheMock.verifyGetImageCalled())
        XCTAssertFalse(apiServiceMock.verifyDidCallFetchImage())
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNotNil(viewModel.image)
    }
    
    func test_loadImage_withNilURL() async {
        // GIVEN
        let apiServiceMock = MockRecipeAPIService()
        let cacheMock = MockImageCache()
        let imageId = "1234"
        
        let viewModel = RecipeImageViewModel(
            apiService: apiServiceMock,
            cache: cacheMock,
            imageURL: nil,
            imageId: imageId
        )
        
        // WHEN
        await viewModel.loadImage()
        
        // THEN
        let errorDescription = viewModel.errorMessage
        let expectedErrorDescription = FetchError.nilURL.errorDescription
        XCTAssertEqual(errorDescription, expectedErrorDescription)
        XCTAssertFalse(cacheMock.verifyGetImageCalled())
        XCTAssertFalse(apiServiceMock.verifyDidCallFetchImage())
        XCTAssertNil(viewModel.image)
    }
    
    func test_loadImage_throwsErrorFromAPIService_fetchError() async throws {
        // GIVEN
        let apiServiceMock = MockRecipeAPIService()
        let cacheMock = MockImageCache()
        let imageURL = try XCTUnwrap(URL(string: "https://validURL.com/superValid"))
        let imageId = "1234"
        
        let viewModel = RecipeImageViewModel(
            apiService: apiServiceMock,
            cache: cacheMock,
            imageURL: imageURL,
            imageId: imageId
        )
        
        // Simluate thrown fetch error
        let error = FetchError.imageDecodingFailed
        apiServiceMock.shouldThrowForFetchImage = true
        apiServiceMock.imageError = error
        
        // WHEN
        await viewModel.loadImage()
        
        // THEN
        let errorDescription = viewModel.errorMessage
        let expectedErrorDescription = error.errorDescription
        XCTAssertEqual(errorDescription, expectedErrorDescription)
        XCTAssertNil(viewModel.image)
    }
    
    func test_loadImage_throwsErrorFromAPIService_unexpectedError() async throws {
        // GIVEN
        let apiServiceMock = MockRecipeAPIService()
        let cacheMock = MockImageCache()
        let imageURL = try XCTUnwrap(URL(string: "https://validURL.com/superValid"))
        let imageId = "1234"
        
        let viewModel = RecipeImageViewModel(
            apiService: apiServiceMock,
            cache: cacheMock,
            imageURL: imageURL,
            imageId: imageId
        )
        
        // Simulate thrown generic error, should fall under second catch block
        apiServiceMock.shouldThrowForFetchImage = true
        apiServiceMock.imageError = GenericError.failed
        
        // WHEN
        await viewModel.loadImage()
        
        // THEN
        let errorDescription = viewModel.errorMessage
        let expectedErrorDescription = FetchError.unexpected.errorDescription
        XCTAssertEqual(errorDescription, expectedErrorDescription)
        XCTAssertNil(viewModel.image)
    }
}
