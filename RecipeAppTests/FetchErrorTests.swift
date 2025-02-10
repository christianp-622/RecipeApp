//
//  FetchErrorTests.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/5/25.
//

import XCTest
@testable import RecipeApp

private enum Constants {
    enum ErrorDescription {
        static let malformedRecipeDataErrorText = "The recipe data is missing required fields"
        static let emptyRecipeDataErrorText = "There is no current recipe data on the server"
        static let nilURLErrorText = "The provided URL was nil"
        static let invalidRecipeResponseErrorText = "Failed to retrieve a valid response from the server"
        static let imageDecodingFailedErrorText = "Failed to decode the image from the given URL"
        static let unexpectedErrorText = "An unexpected error occured"
    }
}

final class FetchErrorTests: XCTestCase {

    func test_fetchError_case_malformedRecipeData() {
        // GIVEN
        let expectedResult = Constants.ErrorDescription.malformedRecipeDataErrorText
        
        // WHEN
        let result = FetchError.malformedRecipeData.errorDescription
        
        // THEN
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_fetchError_case_emptyRecipeData() {
        // GIVEN
        let expectedResult = Constants.ErrorDescription.emptyRecipeDataErrorText
        
        // WHEN
        let result = FetchError.emptyRecipeData.errorDescription
        
        // THEN
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_fetchError_case_nilURLErrorText() {
        // GIVEN
        let expectedResult = Constants.ErrorDescription.nilURLErrorText
        
        // WHEN
        let result = FetchError.nilURL.errorDescription
        
        // THEN
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_fetchError_case_invalidRecipeResponse() {
        // GIVEN
        let expectedResult = Constants.ErrorDescription.invalidRecipeResponseErrorText
        
        // WHEN
        let result = FetchError.invalidRecipeResponse.errorDescription
        
        // THEN
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_fetchError_case_imageDecodingFailed() {
        // GIVEN
        let expectedResult = Constants.ErrorDescription.imageDecodingFailedErrorText
        
        // WHEN
        let result = FetchError.imageDecodingFailed.errorDescription
        
        // THEN
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_fetchError_case_unexpected() {
        // GIVEN
        let expectedResult = Constants.ErrorDescription.unexpectedErrorText
        
        // WHEN
        let result = FetchError.unexpected.errorDescription
        
        // THEN
        XCTAssertEqual(result, expectedResult)
    }
}
