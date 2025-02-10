//
//  NetworkManager.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/5/25.
//

import Foundation

class NetworkManager: NetworkManagerProtocol {
    func requestData(from url: URL) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(from: url)
    }
}
