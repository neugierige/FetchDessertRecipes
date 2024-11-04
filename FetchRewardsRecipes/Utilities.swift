//
//  Utilities.swift
//  FetchRewardsRecipes
//
//  Created by Luyuan Nathan on 11/4/24.
//

import Foundation

extension URL {
    init?(maybeString: String?) {
        guard let string = maybeString else { return nil }
        self.init(string: string)
    }
}
