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
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .error:
                    errorView
                case .loading:
                    loadingView
                case .loaded:
                    loadedView
                }
            }
            .navigationTitle("Dessert recipe library")
        }
        .onAppear {
            if viewModel.state != .loaded {
                Task {
                    try await viewModel.loadRecipes()
                }
            }
        }
    }
    
    var errorView: some View {
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
            
            if let error = viewModel.error {
                Spacer()
                    .frame(height: 16)
                    .listRowSeparator(.hidden)
                HStack {
                    Spacer()
                    Text(error.localizedDescription)
                        .multilineTextAlignment(.center)
                        
                        .refreshable {
                            Task {
                                try await viewModel.loadRecipes()
                            }
                        }
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable {
            Task {
                try await viewModel.loadRecipes()
            }
        }
    }
    
    var loadingView: some View {
        VStack {
            Text("Loading...")
            Spacer()
                .frame(height: 16)
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
    
    var loadedView: some View {
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
