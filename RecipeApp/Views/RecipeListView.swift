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
            Group {
                switch viewModel.viewState {
                case .idle:
                    ProgressView(Constants.progressViewText)
                        .padding()
                case .loading:
                   ProgressView(Constants.progressViewText)
                       .padding()
                case .loaded(let recipes):
                   List(recipes) { recipe in
                       RecipeRowView(recipe: recipe)
                   }
                case .errorMessage(let message):
                   if message == FetchError.emptyRecipeData.errorDescription {
                       Text("No recipes available at this Moment :(")
                   }
                }
            }
            .navigationTitle(Constants.navigationTitleText)
        }
        .refreshable {
            await viewModel.refreshRecipes()
        }
        .task {
            await viewModel.loadRecipes()
        }
        .alert(Constants.alertTitleText, isPresented: Binding<Bool>(
            get: {
                if case .errorMessage(let message) = viewModel.viewState,
                   message != FetchError.emptyRecipeData.errorDescription {
                    return true
                }
                return false
            },
            set: { newValue in
                if !newValue {
                    viewModel.viewState = .idle
                }
            }
        )) {
            Button(Constants.alertButtonTitleText, role: .cancel) { }
        } message: {
            if case .errorMessage(let message) = viewModel.viewState {
                Text(message ?? Constants.backupErrorMessage)
            }
        }
    }
}

#Preview {
    RecipeListView()
}
