//
//  DataProvider.swift
//  FetchRewardsRecipes
//
//  Created by Luyuan Nathan on 11/5/24.
//

import Foundation

protocol IURLSession {
    func loadUrl<T: Decodable>(
        _ url: URL,
        jsonDecoder: JSONDecoder,
        cachePolicy: NSURLRequest.CachePolicy) async throws -> T
}

class DataProvider: IURLSession {
    func loadUrl<T>(
        _ url: URL,
        jsonDecoder: JSONDecoder,
        cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy) async throws -> T where T : Decodable
    {
        return try await URLSession.shared.loadUrl(url, jsonDecoder: jsonDecoder, cachePolicy: cachePolicy)
    }
}

extension URLSession: IURLSession {
    func loadUrl<T>(
        _ url: URL,
        jsonDecoder: JSONDecoder,
        cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy) async throws -> T where T : Decodable
    {
        let request = URLRequest(url: url, cachePolicy: cachePolicy)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedData = try jsonDecoder.decode(T.self, from: data)
        return decodedData
    }
}
