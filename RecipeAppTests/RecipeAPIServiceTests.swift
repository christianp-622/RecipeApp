//
//  RecipeAPIServiceTests.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/5/25.
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

final class RecipeAPIServiceTests: XCTestCase {
    
    private var networkManagerMock: MockNetworkManager!
    
    // System under test
    private var recipeAPIService: RecipeAPIServiceProtocol!
    
    override func setUp() {
        super.setUp()
        networkManagerMock = MockNetworkManager()
        recipeAPIService = RecipeAPIService(networkManager: networkManagerMock)
    }
    
    override func tearDown()  {
        networkManagerMock = nil
        recipeAPIService = nil
        super.tearDown()
    }
    
    func test_fetchRecipes_validEndpoint() async throws {
        // GIVEN
        let validEndpoint = Endpoint.recipesData
        let json = MockData.validRecipes
        
        networkManagerMock.mockData = json
        networkManagerMock.mockResponse = HTTPURLResponse()
        
        let expectedResult = [
            Constants.malaysianRecipeStub,
            Constants.britishRecipeStub
        ]
        
        // WHEN
        let result = try await recipeAPIService.fetchRecipes(from: validEndpoint)
        
        // THEN
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_fetchRecipes_emptyData() async throws {
        // GIVEN
        let emptyDataEndpoint = Endpoint.emptyData
        let json = MockData.emptyRecipes
        
        networkManagerMock.mockData = json
        networkManagerMock.mockResponse = HTTPURLResponse()
        
        let expectedError = FetchError.emptyRecipeData
    
        
        do {
            // WHEN
            _ = try await recipeAPIService.fetchRecipes(from: emptyDataEndpoint)
            
            XCTFail("Expected empty recipe data error")
        } catch let error as FetchError {
            // THEN
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func test_fetchRecipes_malformedRecipeData() async throws {
        // GIVEN
        let malformedDataEndpoint = Endpoint.malformedData
        let json = MockData.malformedRecipes
        
        networkManagerMock.mockData = json
        networkManagerMock.mockResponse = HTTPURLResponse()
        
        let expectedError = FetchError.malformedRecipeData
        
        do {
            // WHEN
            _ = try await recipeAPIService.fetchRecipes(from: malformedDataEndpoint)
            
            XCTFail("Expected malformed recipe data error")
        } catch let error as FetchError {
            // THEN
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func test_fetchRecipes_nilURL() async throws {
        // GIVEN
        let nilURLEndpoint = Endpoint.nilURL
        let expectedError = FetchError.nilURL
        
        do {
            // WHEN
            _ = try await recipeAPIService.fetchRecipes(from: nilURLEndpoint)
            
            XCTFail("Expected invalid URL error")
        } catch let error as FetchError {
            // THEN
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func test_fetchRecipes_invalidURL() async throws {
        // GIVEN
        let invalidURLEndpoint = Endpoint.invalidResponse
        let expectedError = FetchError.invalidRecipeResponse
        
        do {
            // WHEN
            _ = try await recipeAPIService.fetchRecipes(from: invalidURLEndpoint)
            
            XCTFail("Expected invalid URL error")
        } catch let error as FetchError {
            // THEN
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func test_fetchImage_customPath_() {
        
    }
}
