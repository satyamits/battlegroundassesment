//
//  PostClient.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 01/10/25.
//

import Foundation
public protocol PostClientProtocol {
    func fetchPosts() async throws -> [Post]
}

public final class PostClient: PostClientProtocol {
    public init() {}
    
    public func fetchPosts() async throws -> [Post] {
        let result: [Post] = try await APIService.shared.request(PostRouter.fetchPosts, responseType: [Post].self)
        return result
    }
}
