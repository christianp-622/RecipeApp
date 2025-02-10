//
//  Recipe.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/7/25.
//

import Foundation

struct Recipe: Identifiable, Equatable {
    let cuisine: String
    let name: String
    let photoURLLarge: URL?
    let photoURLSmall: URL?
    let sourceURL: URL?
    let uuid: String
    let youtubeURL: URL?
    
    var id: String { uuid }
    var preferredImageURL: URL? {
        return photoURLSmall ?? photoURLLarge
    }
    
    init?(from dto: RecipeDTO) {
        guard let cuisine = dto.cuisine,
              let name = dto.name,
              let uuid = dto.uuid else {
            return nil
        }
        
        self.cuisine = cuisine
        self.name = name
        self.photoURLLarge = dto.photoURLLarge
        self.photoURLSmall = dto.photoURLSmall
        self.sourceURL = dto.sourceURL
        self.uuid = uuid
        self.youtubeURL = dto.youtubeURL
    }
    
    init(cuisine: String,
         name: String,
         photoURLLarge: URL?,
         photoURLSmall: URL?,
         sourceURL: URL?,
         uuid: String,
         youtubeURL: URL?
    ) {
        self.cuisine = cuisine
        self.name = name
        self.photoURLLarge = photoURLLarge
        self.photoURLSmall = photoURLSmall
        self.sourceURL = sourceURL
        self.uuid = uuid
        self.youtubeURL = youtubeURL
    }
}
