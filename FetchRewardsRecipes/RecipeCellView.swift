//
//  RecipeCellView.swift
//  FetchRewardsRecipes
//
//  Created by Luyuan Nathan on 11/4/24.
//

import SwiftUI
import Kingfisher

struct RecipeCellView: View {
    @Environment(\.openURL) var openURL
    
    let recipe: ValidRecipe
    
    var body: some View {
        ZStack {
            HStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(recipe.name)
                            .font(.headline)
                            .underline()
                        Text(recipe.cuisine)
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .onTapGesture {
                    openURL(recipe.sourceUrl)
                }
                
                KFImage(URL(maybeString: recipe.photoUrlSmall))
                    .placeholder { Image(systemName: "questionmark.circle") }
                    .resizable()
                    .scaledToFill()
                    .accessibilityLabel("\(recipe.name) recipe")
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .onTapGesture {
                        if let videoUrl = URL(maybeString: recipe.youtubeUrl) {
                            openURL(videoUrl)
                        }
                    }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        }
        .background(.yellow.opacity(0.3))
        .cornerRadius(12)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    List {
        RecipeCellView(recipe: demoRecipe)
        RecipeCellView(recipe: demoRecipe)
    }
    .listStyle(.plain)
}

let demoRecipe = ValidRecipe(
    name: "Banana Pancakes",
    sourceUrl: URL(string: "https://www.bbcgoodfood.com/recipes/banana-pancakes")!,
    cuisine: "American",
    photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg",
    photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg",
    youtubeUrl: "https://www.youtube.com/watch?v=kSKtb2Sv-_U",
    uuid: "74f6d4eb-da50-4901-94d1-deae2d8af1d1"
)


