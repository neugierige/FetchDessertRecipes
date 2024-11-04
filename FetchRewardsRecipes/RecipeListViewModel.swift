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
    
    @Published
    var state: State
    
    struct NoRecipesError: Error {}
    
    var recipies: [ValidRecipe] = []
    var error: Error? = nil
    
    private let jsonDecoder = JSONDecoder()
    
    init(state: State = .loading) {
        self.state = state
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    
    func loadRecipes() async throws {
        do {
            let data = try await URLSession.loadAsync(url: RecipeListViewModel.recipeUrl)
            let response = try jsonDecoder.decode(RecipeList.self, from: data)
            let validRecipes = response.recipes
                .compactMap { $0.asValidRecipe }
                .sorted { $0.name < $1.name }
            
            if !validRecipes.isEmpty {
                self.recipies = validRecipes
                await setState(.loaded)
            } else {
                self.error = NoRecipesError()
                await setState(.error)
            }
        }
        catch {
            self.error = error
            await setState(.error)
        }
    }
    
    @MainActor
    private func setState(_ state: State, error: Error? = nil) {
        self.state = state
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
