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

}
