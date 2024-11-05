//
//  RecipeListView.swift
//  FetchRewardsRecipes
//
//  Created by Luyuan Nathan on 10/31/24.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject var viewModel: RecipeListViewModel
    
    init(viewModel: RecipeListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .error(let error):
                    List {
                        Spacer()
                            .frame(height: 100)
                            .listRowSeparator(.hidden)
                        HStack {
                            Spacer()
                            Text("Something went wrong, please try again.")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        
                        Spacer()
                            .frame(height: 16)
                            .listRowSeparator(.hidden)
                        
                        HStack {
                            Spacer()
                            Text(error.localizedDescription)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        Task {
                            try await viewModel.loadRecipes(isReload: true)
                        }
                    }
                case .loading:
                    VStack {
                        Text("Loading...")
                        Spacer()
                            .frame(height: 16)
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                case .loaded(let recipes):
                    List {
                        ForEach(recipes) { recipe in
                            RecipeCellView(recipe: recipe)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        Task {
                            try await viewModel.loadRecipes(isReload: true)
                        }
                    }
                }
            }
            .navigationTitle("Dessert recipe library")
        }
        .onAppear {
            if viewModel.state.shouldLoad {
                Task {
                    try await viewModel.loadRecipes()
                }
            }
        }
    }
}

#Preview {
    let dataProvider = DataProvider()
    let vm = RecipeListViewModel(
        sourceUrl: RecipeListViewModel.recipeUrl,
        dataProvider: dataProvider
    )
    RecipeListView(viewModel: vm)
}
