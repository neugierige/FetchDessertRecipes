//
//  RecipeCellView.swift
//  FetchRewardsRecipes
//
//  Created by Luyuan Nathan on 11/4/24.
//

import SwiftUI
import Kingfisher


struct LayoutGuide {
    static let gutter: CGFloat = 16
    static let lineSpacing: CGFloat = 8
    static let imageDimension: CGFloat = 80
    static let iconDimension: CGFloat = 50
}

struct RecipeCellView: View {
    @Environment(\.openURL) var openURL
    
    let recipe: ValidRecipe
    
    var body: some View {
        ZStack {
            HStack(spacing: LayoutGuide.gutter) {
                HStack {
                    VStack(alignment: .leading, spacing: LayoutGuide.lineSpacing) {
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
                
                if let videoUrl = URL(maybeString: recipe.youtubeUrl) {
                    ZStack {
                        recipeImage
                        Button {
                            openURL(videoUrl)
                        } label: {
                            playIcon
                        }
                    }
                } else {
                    recipeImage
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(LayoutGuide.gutter)
        }
        .background(.yellow.opacity(0.3))
        .cornerRadius(12)
        .listRowSeparator(.hidden)
    }
    
    var recipeImage: some View {
        KFImage(URL(maybeString: recipe.photoUrlSmall))
            .placeholder { Image(systemName: "questionmark.circle") }
            .resizable()
            .scaledToFill()
            .accessibilityLabel("\(recipe.name) recipe")
            .frame(width: LayoutGuide.imageDimension, height: LayoutGuide.imageDimension)
            .cornerRadius(8)
    }
    
    var playIcon: some View {
        Image(systemName: "play.circle")
            .resizable()
            .foregroundStyle(.white)
            .frame(width: LayoutGuide.iconDimension, height: LayoutGuide.iconDimension)
            .opacity(0.6)
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


