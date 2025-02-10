//
//  MockRecipeAPIService.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/9/25.
//

import Foundation
import SwiftUI
@testable import RecipeApp

class MockRecipeAPIService: RecipeAPIServiceProtocol {
    
    // Return values
    var recipesToReturn: [Recipe]? = nil
    var imageToReturn: UIImage? = nil
    
    // Error for fetchRecipes
    var shouldThrowForFetchRecipes: Bool = false
    var recipesError: Error? = nil
    
    // Error for fetchImage
    var shouldThrowForFetchImage: Bool = false
    var imageError: Error? = nil
    
    // Check was called. Dont want to write from the outside
    private var didCallFetchRecipes: Bool = false
    private var didCallFetchImage: Bool = false
    
    func fetchRecipes(from endpoint: Endpoint) async throws -> [Recipe] {
        didCallFetchRecipes = true
        
        if shouldThrowForFetchRecipes {
            if let error = recipesError {
                throw error
            }
            throw FetchError.emptyRecipeData
        }
        
        guard let recipes = recipesToReturn else {
            throw FetchError.emptyRecipeData
        }
        return recipes
    }
    
    func fetchImage(from endpoint: Endpoint) async throws -> UIImage {
        didCallFetchImage = true
        
        if shouldThrowForFetchImage {
            if let error = imageError {
                throw error
            }
            throw FetchError.imageDecodingFailed
        }
        
        guard let image = imageToReturn else {
            throw FetchError.imageDecodingFailed
        }
        return image
    }
}


extension MockRecipeAPIService {
    func verifyDidCallFetchRecipes() -> Bool {
        return didCallFetchRecipes
    }
    
    func verifyDidCallFetchImage() -> Bool {
        return didCallFetchImage
    }

}

