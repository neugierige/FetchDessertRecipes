//
//  DataValidityTests.swift
//  FetchRewardsRecipesTests
//
//  Created by Luyuan Nathan on 11/5/24.
//

import Testing
import Foundation

@testable import FetchRewardsRecipes

struct DataValidityTests {

    @Test func emptyResponseTest() async throws {
        let dataProvider = DataProvider()
        let badUrl = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
        let vm = RecipeListViewModel(sourceUrl: badUrl, dataProvider: dataProvider)
        
        await #expect(throws: RecipeListViewModel.NoRecipesError.self) {
            try await vm.loadRecipes()
        }
        #expect(vm.state == .error)
    }
    
    @Test func malFormedDataTest() async throws {
        let dataProvider = DataProvider()
        let malformedUrl = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let recipeList: RecipeList = try await dataProvider.loadUrl(malformedUrl, jsonDecoder: jsonDecoder)
        
        let vm = RecipeListViewModel(sourceUrl: malformedUrl, dataProvider: dataProvider)
        try await vm.loadRecipes()
        
        // RecipeListViewModel uses ValidRecipe, which excludes malformed recipe JSON
        #expect(recipeList.recipes.count > vm.recipes.count)
    }

}
