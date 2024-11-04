//
//  RecipeListViewModel.swift
//  FetchRewardsRecipes
//
//  Created by Luyuan Nathan on 11/4/24.
//

import Foundation

class RecipeListViewModel: ObservableObject {
    
    enum State {
        case loading, loaded, error
    }
    
    @Published
    var state: State = .loading
    var recipies: [ValidRecipe] = []
    
    let jsonDecoder = JSONDecoder()
    static let recipeUrl = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    
    @MainActor
    private func setState(_ state: State, error: Error? = nil) {
        self.state = state
        
    }
    
    func loadRecipes() async throws -> [ValidRecipe] {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        struct NoRecipesError: Error {}
        
        let data = try await URLSession.loadAsync(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!)
        let response = try jsonDecoder.decode(RecipeList.self, from: data)
        let validRecipes = response.recipes
            .compactMap { $0.asValidRecipe }
            .sorted { $0.name < $1.name }
        
        if !validRecipes.isEmpty {
            self.recipies = validRecipes
            await setState(.loaded)
        } else {
            await setState(.error)
        }
        return validRecipes
    }
}


extension URLSession {
    
    static func loadAsync(url: URL) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            loadUrl(url) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    static func loadUrl(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy
        )
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let data {
                completion(.success(data))
            } else if let error {
                completion(.failure(error))
            }
        }
        
        task.resume()
        
    }
}
