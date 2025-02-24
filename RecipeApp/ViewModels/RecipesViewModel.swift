//
//  RecipesViewModel.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/1/25.
//

import Foundation
import SwiftUI

final class RecipesViewModel: ObservableObject {
    
    @Published var viewState: ViewState<[Recipe]> = .idle
    
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
        await setLoadingState()
        
        do {
            let fetchedRecipes = try await apiService.fetchRecipes(from: endpoint)
            await setRecipesState(fetchedRecipes)
        } catch let error as FetchError {
            await setErrorState(error.errorDescription)
        } catch {
            await setErrorState(FetchError.unexpected.errorDescription)
        }
    }
    
    func refreshRecipes() async {
        cache.clearCache()
        await setshuffleRecipesState()
    }
}

// MARK: - MainActor Helpers
@MainActor
private extension RecipesViewModel {
    func setLoadingState() {
        self.viewState = .loading
    }
    
    func setErrorState(_ message: String?) {
        self.viewState = .errorMessage(message)
    }
    
    func setRecipesState(_ recipes: [Recipe]) {
        self.viewState = .loaded(recipes)
    }
    
    func setshuffleRecipesState() {
        if case .loaded(var recipes) = viewState {
            recipes.shuffle()
            self.viewState = .loaded(recipes)
        }
    }
}
