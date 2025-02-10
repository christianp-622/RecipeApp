//
//  FetchError.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/5/25.
//

import Foundation

private enum Constants {
    static let malformedRecipeDataErrorText = "The recipe data is missing required fields"
    static let emptyRecipeDataErrorText = "There is no current recipe data on the server"
    static let nilURLErrorText = "The provided URL was nil"
    static let invalidRecipeResponseErrorText = "Failed to retrieve a valid response from the server"
    static let imageDecodingFailedErrorText = "Failed to decode the image from the given URL"
    static let unexpectedErrorText = "An unexpected error occured"
}

enum FetchError: Error {
    case malformedRecipeData
    case emptyRecipeData
    case nilURL
    case invalidRecipeResponse
    case imageDecodingFailed
    case unexpected
    
    var errorDescription: String {
        switch self {
        case .malformedRecipeData:
            return Constants.malformedRecipeDataErrorText
        case .emptyRecipeData:
            return Constants.emptyRecipeDataErrorText
        case .nilURL:
            return Constants.nilURLErrorText
        case .invalidRecipeResponse:
            return Constants.invalidRecipeResponseErrorText
        case .imageDecodingFailed:
            return Constants.imageDecodingFailedErrorText
        case .unexpected:
            return Constants.unexpectedErrorText
        }
    }
}
