//
//  FetchRewardsRecipesApp.swift
//  FetchRewardsRecipes
//
//  Created by Luyuan Nathan on 10/31/24.
//

import SwiftUI

@main
struct FetchRewardsRecipesApp: App {
    
    let recipeViewModel = RecipeListViewModel()
    
    var body: some Scene {
        WindowGroup {
            RecipeListView(viewModel: recipeViewModel)
        }
    }
}
