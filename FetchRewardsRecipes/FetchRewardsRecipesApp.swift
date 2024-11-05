//
//  FetchRewardsRecipesApp.swift
//  FetchRewardsRecipes
//
//  Created by Luyuan Nathan on 10/31/24.
//

import SwiftUI

@main
struct FetchRewardsRecipesApp: App {
    
    var body: some Scene {
        WindowGroup {
            let dataProvider = DataProvider()
            let vm = RecipeListViewModel(dataProvider: dataProvider)
            RecipeListView(viewModel: vm)
        }
    }
}
