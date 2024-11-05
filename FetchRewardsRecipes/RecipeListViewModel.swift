//
//  RecipeListViewModel.swift
//  FetchRewardsRecipes
//
//  Created by Luyuan Nathan on 11/4/24.
//

import Foundation

class RecipeListViewModel: ObservableObject {
    
    static let recipeUrl = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    
    enum State {
        case loading, loaded, error
    }
    
    @Published var state: State
    var dataProvider: IURLSession
    
    struct NoRecipesError: Error {}
    
    @Published var recipes: [ValidRecipe] = []
    
    @Published var error: Error? = nil
    
    private let jsonDecoder = JSONDecoder()
    
    init(state: State = .loading, dataProvider: IURLSession) {
        self.state = state
        self.dataProvider = dataProvider
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func loadRecipes(isReload: Bool = false) async throws {
        let recipeList: RecipeList = try await dataProvider.loadUrl(
            RecipeListViewModel.recipeUrl,
            jsonDecoder: jsonDecoder,
            cachePolicy: isReload ? .reloadIgnoringLocalAndRemoteCacheData : .useProtocolCachePolicy
        )
        
        let validRecipes = recipeList.recipes
            .compactMap { $0.asValidRecipe }
            .sorted { $0.name < $1.name }
        
        if validRecipes.isEmpty {
            let error = NoRecipesError()
            self.error = error
            await self.setState(.error)
            throw error
        } else {
            self.recipes = validRecipes
            await self.setState(.loaded)
        }
    }
    
    @MainActor
    private func setState(_ state: State, error: Error? = nil) {
        self.state = state
    }
}
