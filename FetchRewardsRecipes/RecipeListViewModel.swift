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
        case loading
        case loaded(recipes: [ValidRecipe])
        case error(Error)
        
        var shouldLoad: Bool {
            return switch self {
            case .loaded: false
            default: true
            }
        }
    }
    
    @Published var state: State
    var sourceUrl: URL
    var dataProvider: IURLSession
    
    struct NoRecipesError: Error {}
    
    private let jsonDecoder = JSONDecoder()
    
    init(
        state: State = .loading,
        sourceUrl: URL,
        dataProvider: IURLSession
    ) {
        self.state = state
        self.sourceUrl = sourceUrl
        self.dataProvider = dataProvider
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func loadRecipes(isReload: Bool = false) async throws {
        let recipeList: RecipeList = try await dataProvider.loadUrl(
            sourceUrl,
            jsonDecoder: jsonDecoder,
            cachePolicy: isReload ? .reloadIgnoringLocalAndRemoteCacheData : .useProtocolCachePolicy
        )
        
        let validRecipes = recipeList.recipes
            .compactMap { $0.asValidRecipe }
            .sorted { $0.name < $1.name }
        
        if validRecipes.isEmpty {
            let error = NoRecipesError()
            await self.setState(.error(error))
            throw error
        } else {
            await self.setState(.loaded(recipes: validRecipes))
        }
    }
    
    @MainActor
    private func setState(_ state: State) {
        self.state = state
    }
}
