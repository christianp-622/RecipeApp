//
//  RecipeImageViewModel.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/5/25.
//

import Foundation
import SwiftUI

/*
 Note in this implementation, the error state is there to handle errors throws in the API.
 It is not used in the UI, but could be used if need be. An empty default image would be loaded
 into the UI if an error were propogated.
 */

final class RecipeImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let cache: ImageCacheProtocol
    private let apiService: RecipeAPIServiceProtocol
    private let imageURL: URL?
    private let imageId: String
    
    init(apiService: RecipeAPIServiceProtocol = RecipeAPIService.shared,
         cache: ImageCacheProtocol = HybridImageCache.shared,
         imageURL: URL?,
         imageId: String
    ) {
        self.apiService = apiService
        self.cache = cache
        self.imageURL = imageURL
        self.imageId = imageId
    }
    
    func loadImage() async {
        guard let url = imageURL,
              let path = URLComponents(url: url, resolvingAgainstBaseURL: false)?.path
        else {
            await setErrorState(FetchError.nilURL.errorDescription)
            return
        }
        
        let cacheKey = imageId
        
        // Check cache
        if let cachedImage = cache.getImage(forKey: cacheKey) {
            await updateImage(cachedImage)
            return
        }
        
        // Initiate download
        await setLoadingState(true)
        
        do {
            let endpoint = Endpoint.image(path: path)
            let fetchedImage = try await apiService.fetchImage(from: endpoint)
            
            // Cache the image
            cache.addImage(forKey: cacheKey, value: fetchedImage)
            await updateImage(fetchedImage)
            
        } catch let error as FetchError {
            await setErrorState(error.errorDescription)
        } catch {
            await setErrorState(FetchError.unexpected.errorDescription)
        }
        
        await setLoadingState(false)
    }
    
}

// MARK: - MainActor Helpers
@MainActor
private extension RecipeImageViewModel {
    func updateImage(_ image: UIImage) {
        self.image = image
    }
    
    func setLoadingState(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func setErrorState(_ message: String?) {
        self.errorMessage = message
        self.image = nil
    }
}
