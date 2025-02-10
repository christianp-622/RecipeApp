//
//  Endpoint.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/5/25.
//

import Foundation

private enum Constants {
    enum Path {
        static let urlRecipesPathText = "/recipes.json"
        static let urlMalformedDataPathText = "/recipes-malformed.json"
        static let urlemptyDataPathText = "/recipes-empty.json"
        static let badURLPathText = "/abcdefg.hijklmnop"
    }
    
    enum Scheme {
        static let urlSchemeText = "https"
    }
    
    enum Host {
        static let urlHostText = "d3jbb8n5wk0qxi.cloudfront.net"
    }
}

enum Endpoint {
    case recipesData
    case malformedData
    case emptyData
    case invalidResponse
    case image(path: String)
    case nilURL

    var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.Scheme.urlSchemeText
        components.host = Constants.Host.urlHostText
        
        switch self {
        case .recipesData:
            components.path = Constants.Path.urlRecipesPathText
            
        case .malformedData:
            components.path = Constants.Path.urlMalformedDataPathText
            
        case .emptyData:
            components.path = Constants.Path.urlemptyDataPathText
            
        case .invalidResponse:
            components.path = Constants.Path.badURLPathText
            
        case .image(let path):
            components.path = path
            
        case .nilURL:
            return nil
        }
        
        return components.url
    }
}

