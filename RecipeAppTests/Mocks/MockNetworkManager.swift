//
//  MockNetworkManager.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/8/25.
//

import Foundation
@testable import RecipeApp

class MockNetworkManager: NetworkManagerProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func requestData(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        guard let data = mockData, let response = mockResponse else {
            throw FetchError.invalidRecipeResponse
        }
        return (data, response)
    }
}
