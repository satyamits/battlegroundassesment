//
//  Post.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 01/10/25.
//

import Foundation

// MARK: - Post
public struct Post: Codable {
    public let userID, id: Int?
    public let title, body: String?

    public enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }

    public init(userID: Int?, id: Int?, title: String?, body: String?) {
        self.userID = userID
        self.id = id
        self.title = title
        self.body = body
    }
}
