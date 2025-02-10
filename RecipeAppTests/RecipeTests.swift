//
//  RecipeTests.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/9/25.
//

import XCTest
@testable import RecipeApp

private enum Constants {
    static let recipeDTOWithValidDataStub = RecipeDTO(
        cuisine: "Italian",
        name: "Pizza",
        photoURLLarge: URL(string: "https://example.com/large.jpg"),
        photoURLSmall: URL(string: "https://example.com/small.jpg"),
        sourceURL: URL(string: "https://example.com"),
        uuid: "1234",
        youtubeURL: URL(string: "https://youtube.com/video")
    )
    
    static let recipeDTOWithInvalidDataStub = RecipeDTO(
        cuisine: nil,
        name: nil,
        photoURLLarge: URL(string: "https://example.com/large.jpg"),
        photoURLSmall: URL(string: "https://example.com/small.jpg"),
        sourceURL: URL(string: "https://example.com"),
        uuid: "1234",
        youtubeURL: URL(string: "https://youtube.com/video")
    )
    
    static let recipeDTOWithSmallImageNilButLargeImageNotNilStub = RecipeDTO(
        cuisine: "Italian",
        name: "Pizza",
        photoURLLarge: URL(string: "https://example.com/large.jpg"),
        photoURLSmall: nil,
        sourceURL: URL(string: "https://example.com"),
        uuid: "1234",
        youtubeURL: URL(string: "https://youtube.com/video")
    )
}

final class RecipeTests: XCTestCase {

    func test_initFromDTO_withValidData() {
        // GIVEN
        let dto = Constants.recipeDTOWithValidDataStub
        
        // WHEN
        let recipe = Recipe(from: dto)
        
        // THEN
        XCTAssertNotNil(recipe)
    }
    
    func test_initFromDTO_withInvalidData() {
        // GIVEN
        let dto = Constants.recipeDTOWithInvalidDataStub
        
        // WHEN
        let recipe = Recipe(from: dto)
        
        // THEN
        XCTAssertNil(recipe)
    }
    
    func test_initFromDTO_checkSmallImagePreferedOverLargeImage() throws {
        // GIVEN
        let dto = Constants.recipeDTOWithValidDataStub
        
        // WHEN
        let recipe = try XCTUnwrap(Recipe(from: dto))
        
        // THEN
        XCTAssertEqual(recipe.preferredImageURL, recipe.photoURLSmall)
    }
    
    func test_initFromDTO_checkFallsbackToLargeImage_whenSmallImageURLIsNil() throws {
        // GIVEN
        let dto = Constants.recipeDTOWithSmallImageNilButLargeImageNotNilStub
        
        // WHEN
        let recipe = try XCTUnwrap(Recipe(from: dto))
        
        // THEN
        XCTAssertEqual(recipe.preferredImageURL, recipe.photoURLLarge)
    }
}
