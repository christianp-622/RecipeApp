//
//  RecipesViewModel.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/1/25.
//

import Foundation
import SwiftUI

final class RecipesViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private let apiService: RecipeAPIServiceProtocol
    private let cache: ImageCacheProtocol
    private let endpoint: Endpoint
    
    init(
        apiService: RecipeAPIServiceProtocol = RecipeAPIService.shared,
        cache: ImageCacheProtocol = HybridImageCache.shared,
        endpoint: Endpoint = Endpoint.recipesData
    ) {
        self.apiService = apiService
        self.cache = cache
        self.endpoint = endpoint
    }
    
    func loadRecipes() async {
        await setLoadingState(true)
        await setErrorState(nil)
        
        do {
            let fetchedRecipes = try await apiService.fetchRecipes(from: endpoint)
            await setReciesState(fetchedRecipes)
        } catch let error as FetchError {
            await setErrorState(error.errorDescription)
        } catch {
            await setErrorState(FetchError.unexpected.errorDescription)
        }
        
        await setLoadingState(false)
    }
    
    func refreshRecipes() async {
        cache.clearCache()
        await setshuffleRecipesState()
    }
}

// MARK: - MainActor Helpers
@MainActor
private extension RecipesViewModel {
    func setLoadingState(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func setErrorState(_ message: String?) {
        self.errorMessage = message
    }
    
    func setReciesState(_ recipes: [Recipe]) {
        self.recipes = recipes
    }
    
    func setshuffleRecipesState() {
        self.recipes.shuffle()
    }
}
