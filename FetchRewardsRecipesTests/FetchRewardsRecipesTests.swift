//
//  FetchRewardsRecipesTests.swift
//  FetchRewardsRecipesTests
//
//  Created by Luyuan Nathan on 10/31/24.
//

import Testing
import Foundation

@testable import FetchRewardsRecipes

struct FetchRewardsRecipesTests {
    
    var invalidRecipes: [String] {
        [noNameRecipe, noSourceRecipe]
    }
    
    var validRecipes: [String] {
        [noYouTubeRecipe, noPhotosRecipe]
    }
    
    @Test func testInvalidRecipes() async throws {
        for recipeString in invalidRecipes {
            let decodedRecipe = try convert(recipeString)
            #expect(decodedRecipe.asValidRecipe == nil)
        }
    }
    
    @Test func testValidRecipes() async throws {
        for recipeString in validRecipes {
            let decodedRecipe = try convert(recipeString)
            #expect(decodedRecipe.asValidRecipe == nil)
        }
    }
    
    func convert(_ string: String) throws -> Recipe {
        let data = try #require(string.data(using: .utf8))
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(Recipe.self, from: data)
    }

    let noNameRecipe =
        """
        {
            "cuisine": "Malaysian",
            "name": "",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        }
        """
    
    let noSourceRecipe =
        """
        {
            "cuisine": "Malaysian",
            "name": "Apam Balik",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        }
        """
    
    let noYouTubeRecipe =
        """
        {
            "cuisine": "Malaysian",
            "name": "Apam Balik",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8"
        }
        """
    
    let noPhotosRecipe =
        """
        {
            "cuisine": "Malaysian",
            "name": "Apam Balik",
            "photo_url_large": "foo",
            "photo_url_small": "bar",
            "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        }
        """
}
