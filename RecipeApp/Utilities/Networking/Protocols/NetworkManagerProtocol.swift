//
//  NetworkManagerProtocol.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/8/25.
//

import Foundation

protocol NetworkManagerProtocol {
    func requestData(from url: URL) async throws -> (Data, URLResponse)
}
