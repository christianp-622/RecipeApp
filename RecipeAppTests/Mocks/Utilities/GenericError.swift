//
//  GenericError.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/8/25.
//

import Foundation


enum GenericError: Error, LocalizedError {
    case failed
    
    var errorDescription: String? {
        switch self {
        case .failed:
            return "Failure"
        }
    }
}
