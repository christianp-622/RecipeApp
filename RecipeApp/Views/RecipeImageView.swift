//
//  RecipeImageView.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/5/25.
//

import SwiftUI

struct RecipeImageView: View {
    
    @StateObject private var viewModel: RecipeImageViewModel
    
    init(
        imageURL: URL?,
        imageId: String
    ) {
        _viewModel = StateObject(wrappedValue: RecipeImageViewModel(imageURL: imageURL, imageId: imageId))
    }

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            } else if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .transition(.opacity)
            } else {
                Image("FoodIcon")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
            }
        }
        .onAppear {
            Task {
                await viewModel.loadImage()
            }
        }
    }
}

#Preview {
    RecipeImageView(
        imageURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"),
        imageId: "1234"
    )
}
