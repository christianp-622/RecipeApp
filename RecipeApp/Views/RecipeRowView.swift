//
//  RecipeRowView.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/4/25.
//

import SwiftUI

struct RecipeRowView: View {
    
    var recipe: Recipe
    
    var body: some View {
        VStack {
            RecipeImageView(imageURL: recipe.preferredImageURL, imageId: recipe.id)
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(Circle().stroke(lineWidth: 2))
                .scaledToFit()
            Text("Name: \(recipe.name)")
                .font(.system(size: 30))
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Cuisine: \(recipe.cuisine)")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    RecipeRowView(
        recipe: Recipe(
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoURLLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"),
            photoURLSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"),
            sourceURL: nil,
            uuid: "1",
            youtubeURL: nil
        )
    )
}
