//
//  RecipeListView.swift
//  FetchRewardsRecipes
//
//  Created by Luyuan Nathan on 10/31/24.
//

import SwiftUI

struct RecipeListView: View {
    
    @ObservedObject
    var viewModel: RecipeListViewModel
    
    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .error:
                Text("Something went wrong, please try again.")
            case .loading:
                Text("Loading...")
                ProgressView()
                    .progressViewStyle(.circular)
            case .loaded:
                list
            }
        }
        .onAppear {
            if viewModel.state != .loaded {
                Task {
                    try await viewModel.loadRecipes()
                }
            }
        }
    }
    
    var list: some View {
        List {
            ForEach(viewModel.recipies) { recipe in
                RecipeCellView(recipe: recipe)
            }
        }
        .listStyle(.plain)
        .refreshable {
            Task {
                try await viewModel.loadRecipes()
            }
        }
    }
}

#Preview {
    let vm = RecipeListViewModel()
    RecipeListView(viewModel: vm)
}
