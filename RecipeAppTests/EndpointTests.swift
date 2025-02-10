//
//  EndpointTests.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/5/25.
//

import XCTest
@testable import RecipeApp

final class EndpointTests: XCTestCase {
    
    func test_endpoint_case_recipesData() {
        // GIVEN
        let expectedURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")

        // WHEN
        let result = Endpoint.recipesData.url

        // THEN
        XCTAssertEqual(result, expectedURL)
    }
    
    func test_endpoint_case_malformedData() {
        // GIVEN
        let expectedURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
        
        // WHEN
        let result = Endpoint.malformedData.url
        
        // THEN
        XCTAssertEqual(result, expectedURL)
    }
    
    func test_endpoint_case_emptyData() {
        // GIVEN
        let expectedURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
        
        // WHEN
        let result = Endpoint.emptyData.url
        
        // THEN
        XCTAssertEqual(result, expectedURL)
    }
    
    func test_endpoint_case_invalidResponse() {
        let expectedURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/abcdefg.hijklmnop")

        // WHEN
        let result = Endpoint.invalidResponse.url

        // THEN
        XCTAssertEqual(result, expectedURL)
    }
    
    func test_endpoint_case_nilURL() {
        // GIVEN
        let endpoint = Endpoint.nilURL

        // WHEN
        let result = endpoint.url

        // THEN
        XCTAssertNil(result)
    }
    
    func test_endpoint_case_imageWithPath() {
        let testCases = [
            ("/photos/image1.jpg", "https://d3jbb8n5wk0qxi.cloudfront.net/photos/image1.jpg"),
            ("/assets/pic.png", "https://d3jbb8n5wk0qxi.cloudfront.net/assets/pic.png"),
            ("/abcdefghijklmnop", "https://d3jbb8n5wk0qxi.cloudfront.net/abcdefghijklmnop")
        ]
        
        for (inputPath, expectedURLString) in testCases {
            // GIVEN
            let expectedResult = URL(string: expectedURLString)
            
            // WHEN
            let result = Endpoint.image(path: inputPath).url
            
            // THEN
            XCTAssertEqual(result, expectedResult)
        }
    }
}
