//
//  ViewState.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/23/25.
//

import Foundation

enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case errorMessage(String?)
}
