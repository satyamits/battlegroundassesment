//
//  PostRouter.swift
//  BattleGroundAssement
//
//  Created by Satyam on 01/10/25.
//

import Foundation

public enum PostRouter: Router {
    
    case fetchPosts
    
    
    public var method: HTTPMethod {
        switch self {
        case .fetchPosts:
                .get
        }
    }
    
    public var path: String {
        switch self {
        case .fetchPosts:
            "/posts"
        }
    }
    
    public var encodableBody: Encodable? {
            switch self {
            default: return nil
            }
        }
    
    public var params: Any? {
        switch self {
        default: return nil
        }
    }
    
    public var keypathToMap: String? {
        switch self {
        default: return nil
        }
    }
}
