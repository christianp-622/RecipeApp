//
//  RecipeAPIService.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/5/25.
//

import Foundation
import SwiftUI

private enum Constants {
    static let jsonResponseKey = "recipes"
}

class RecipeAPIService {
    // Shared Instance
    static let shared = RecipeAPIService()
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - RecipeAPIServiceProtocol
extension RecipeAPIService: RecipeAPIServiceProtocol {
    func fetchRecipes(from endpoint: Endpoint) async throws -> [Recipe] {
        let data = try await requestDataAndHandleResponse(from: endpoint)
        
        let decodedResponse = try JSONDecoder().decode([String: [RecipeDTO]].self, from: data)
        
        // Ensure not empty data
        guard let recipesDTO = decodedResponse[Constants.jsonResponseKey], !recipesDTO.isEmpty else {
            throw FetchError.emptyRecipeData
        }
        
        let recipes = recipesDTO.compactMap { Recipe(from: $0) }
        
        // Ensure not malformed data was found
        if recipes.count != recipesDTO.count {
            throw FetchError.malformedRecipeData
        }
        
        return recipes
    }
    
    func fetchImage(from endpoint: Endpoint) async throws -> UIImage {
        let data = try await requestDataAndHandleResponse(from: endpoint)
        
        guard let image = UIImage(data: data) else {
            throw FetchError.imageDecodingFailed
        }
        
        return image
    }
}

// MARK: - Helpers
private extension RecipeAPIService {
    func requestDataAndHandleResponse(from endpoint: Endpoint) async throws -> Data {
        guard let url = endpoint.url else {
            throw FetchError.nilURL
        }

        let (data, response) = try await networkManager.requestData(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200, response.statusCode < 300 else {
            throw FetchError.invalidRecipeResponse
        }

        return data
    }
}
