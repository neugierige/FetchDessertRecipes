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
    
    struct NoRecipesError: Error {}
    
    @Published var recipies: [ValidRecipe] = []
    
    @Published var error: Error? = nil
    
    private let jsonDecoder = JSONDecoder()
    
    init(state: State = .loading) {
        self.state = state
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    @MainActor
    func loadRecipes() async throws {
        
        let recipeList: RecipeList = try await URLSession.loadUrl(RecipeListViewModel.recipeUrl, jsonDecoder: jsonDecoder)
        let validRecipes = recipeList.recipes
            .compactMap { $0.asValidRecipe }
            .sorted { $0.name < $1.name }
        
        if validRecipes.isEmpty {
            self.error = NoRecipesError()
            self.setState(.error)
        } else {
            self.recipes = validRecipes
            self.setState(.loaded)
        }
    }
    
    @MainActor
    private func setState(_ state: State, error: Error? = nil) {
        self.state = state
    }
}


extension URLSession {
    
    static func loadUrl<T: Decodable>(
        _ url: URL,
        jsonDecoder: JSONDecoder,
        cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy) async throws -> T
    {
        let request = URLRequest(url: url, cachePolicy: cachePolicy)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedData = try jsonDecoder.decode(T.self, from: data)
        return decodedData
    }
}
