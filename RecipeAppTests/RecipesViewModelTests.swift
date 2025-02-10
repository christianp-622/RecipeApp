//
//  RecipesViewModelTests.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/9/25.
//

import XCTest
@testable import RecipeApp

private enum Constants {
    static let malaysianRecipeStub = Recipe(
        cuisine: "Malaysian",
        name: "Apam Balik",
        photoURLLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"),
        photoURLSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"),
        sourceURL: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ"),
        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
        youtubeURL: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
    )
    
    static let britishRecipeStub = Recipe(
        cuisine: "British",
        name: "Apple & Blackberry Crumble",
        photoURLLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg"),
        photoURLSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg"),
        sourceURL: URL(string: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble"),
        uuid:  "599344f4-3c5c-4cca-b914-2210e3b3312f",
        youtubeURL: URL(string: "https://www.youtube.com/watch?v=4vhcOwVBDO4")
    )
}

final class RecipesViewModelTests: XCTestCase {

    func test_loadRecipes_success() async throws {
        // GIVEN
        let apiServiceMock = MockRecipeAPIService()
        let cacheMock = MockImageCache()
        let viewModel = RecipesViewModel(
            apiService: apiServiceMock,
            cache: cacheMock
        )
        
        // Simulate fetch request
        let expectedRecipes = [
            Constants.malaysianRecipeStub,
            Constants.britishRecipeStub
        ]
        
        apiServiceMock.recipesToReturn = expectedRecipes
        
        // WHEN
        await viewModel.loadRecipes()
        
        // THEN
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.recipes, expectedRecipes)
    }
    
    func test_loadRecipes_throwsFetchError() async throws {
        // GIVEN
        let apiServiceMock = MockRecipeAPIService()
        let cacheMock = MockImageCache()
        let viewModel = RecipesViewModel(
            apiService: apiServiceMock,
            cache: cacheMock
        )
        
        // Simulate throws error, ensure fetch error was thrown
        let expectedError = FetchError.emptyRecipeData
        apiServiceMock.shouldThrowForFetchRecipes = true
        apiServiceMock.recipesError = expectedError
        
        // WHEN
        await viewModel.loadRecipes()
        
        // THEN
        XCTAssertEqual(viewModel.errorMessage, expectedError.errorDescription)
    }
    
    func test_loadRecipes_throwsUnexpectedError() async throws {
        // GIVEN
        let apiServiceMock = MockRecipeAPIService()
        let cacheMock = MockImageCache()
        let viewModel = RecipesViewModel(
            apiService: apiServiceMock,
            cache: cacheMock
        )
        
        // Simulate throws error, ensure fetch error wasnt thrown,
        // This will test the third catch block
        apiServiceMock.shouldThrowForFetchRecipes = true
        apiServiceMock.recipesError = GenericError.failed
        
        // WHEN
        await viewModel.loadRecipes()
        
        // THEN
        XCTAssertEqual(viewModel.errorMessage, FetchError.unexpected.errorDescription)
    }
    
    func test_refreshRecipes() async {
        // GIVEN
        let apiServiceMock = MockRecipeAPIService()
        let cacheMock = MockImageCache()
        let viewModel = RecipesViewModel(
            apiService: apiServiceMock,
            cache: cacheMock
        )
        
        // Simulate fetch request
        let originalRecipes = [
            Constants.malaysianRecipeStub,
            Constants.britishRecipeStub,
            Constants.malaysianRecipeStub,
            Constants.britishRecipeStub,
            Constants.malaysianRecipeStub,
            Constants.britishRecipeStub,
            Constants.malaysianRecipeStub,
            Constants.britishRecipeStub
        ]
        
        apiServiceMock.recipesToReturn = originalRecipes
        await viewModel.loadRecipes()
        
        XCTAssertEqual(viewModel.recipes, originalRecipes)
        
        // WHEN
        await viewModel.refreshRecipes()
        
        // THEN
        
        // List should not be the same now, should be shuffled
        // (very small chance they are in the same order)
        XCTAssertNotEqual(viewModel.recipes, originalRecipes)
        XCTAssert(cacheMock.verifyClearCacheWasCalled())
    }

}
