//
//  URLRequest+Helpers.swift
//  BattleGroundAssement
//
//  Created by Satyam on 08/07/25.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

extension URLRequest {
    mutating func addHTTPMethod(with httpMethod: HTTPMethod) {
        self.httpMethod = httpMethod.rawValue
    }

    mutating func addAppJsonContentType() {
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    mutating func addAuthorization(withToken token: String) {
        self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}

extension Dictionary where Key == String, Value == Any {
    func valueForKeyPath(_ keyPath: String) -> Any? {
        return keyPath
            .split(separator: ".")
            .reduce(self as Any?) { (result, key) -> Any? in
                if let dict = result as? [String: Any] {
                    return dict[String(key)]
                } else {
                    return nil
                }
            }
    }
}
