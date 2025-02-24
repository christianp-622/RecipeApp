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
        if case .loaded(let image) = viewModel.viewState {
            XCTAssertTrue(cacheMock.verifyGetImageCalled())
            XCTAssertFalse(apiServiceMock.verifyDidCallFetchImage())
        } else {
            XCTFail("Should be in loaded state")
        }
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
        if case .errorMessage(let message) = viewModel.viewState {
            XCTAssertEqual(message, FetchError.nilURL.errorDescription)
        } else {
            XCTFail("Should be in error state when url is nil")
        }
        
        XCTAssertFalse(cacheMock.verifyGetImageCalled())
        XCTAssertFalse(apiServiceMock.verifyDidCallFetchImage())
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
        if case .errorMessage(let message) = viewModel.viewState {
            XCTAssertEqual(message, error.errorDescription)
        } else {
            XCTFail("Shoul be in error state when fetch error")
        }
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
        if case .errorMessage(let message) = viewModel.viewState {
            XCTAssertEqual(message, FetchError.unexpected.errorDescription)
        } else {
            XCTFail("Shoul be in error state when fetch error")
        }
    }
}
