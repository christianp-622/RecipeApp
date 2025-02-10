//
//  RecipeListView.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/5/25.
//

import SwiftUI

private enum Constants {
    static let progressViewText = "Loading recipes"
    static let navigationTitleText = "Recipes"
    static let alertTitleText = "Error"
    static let alertButtonTitleText = "OK"
    static let backupErrorMessage = "An unknown error occurred."
}

struct RecipeListView: View {
    
    @StateObject var viewModel = RecipesViewModel(endpoint: .malformedData)

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView(Constants.progressViewText)
                        .padding()
                    
                } else if isEmptyRecipesErrorMessage() {
                    Text("No recipes available at this Moment :(")
                    
                } else {
                    List(viewModel.recipes) { recipe in
                        RecipeRowView(recipe: recipe)
                    }
                }
            }
            .navigationTitle(Constants.navigationTitleText)
            .refreshable {
                await viewModel.refreshRecipes()
            }
            .task {
                await viewModel.loadRecipes()
            }
            .alert(Constants.alertTitleText, isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil && !isEmptyRecipesErrorMessage() },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button(Constants.alertButtonTitleText, role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? Constants.backupErrorMessage)
            }
        }
    }
    
    func isEmptyRecipesErrorMessage() -> Bool {
        return viewModel.errorMessage == FetchError.emptyRecipeData.errorDescription
    }
}

#Preview {
    RecipeListView()
}
