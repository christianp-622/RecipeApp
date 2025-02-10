//
//  RecipeAPIServiceProtocol.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/8/25.
//

import Foundation
import SwiftUI

protocol RecipeAPIServiceProtocol {
    func fetchRecipes(from endpoint: Endpoint) async throws -> [Recipe]
    func fetchImage(from endpoint: Endpoint) async throws -> UIImage
}
