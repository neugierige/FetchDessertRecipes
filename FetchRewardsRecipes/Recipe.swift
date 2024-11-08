//
//  Recipe.swift
//  FetchRewardsRecipes
//
//  Created by Luyuan Nathan on 11/4/24.
//

import Foundation

struct RecipeList: Decodable {
    var recipes: [Recipe]
}

struct Recipe: Decodable {
    var cuisine: String?
    var name: String?
    var photoUrlLarge: String?
    var photoUrlSmall: String?
    var sourceUrl: String?
    var uuid: String?
    var youtubeUrl: String?
    
    var asValidRecipe: ValidRecipe? {
        guard let cuisine,
              let name, !name.isEmpty,
              let url = URL(maybeString: sourceUrl)
        else { return nil }
        
        return ValidRecipe(
            name: name,
            sourceUrl: url,
            cuisine: cuisine,
            photoUrlLarge: photoUrlLarge,
            photoUrlSmall: photoUrlSmall,
            youtubeUrl: youtubeUrl,
            uuid: uuid ?? UUID().uuidString
        )
    }
}

struct ValidRecipe {
    var name: String
    var sourceUrl: URL
    var cuisine: String
    var photoUrlLarge: String?
    var photoUrlSmall: String?
    var youtubeUrl: String?
    var uuid: String
}

extension ValidRecipe: Identifiable {
    var id: String { uuid }
}
