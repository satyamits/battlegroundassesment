//
//  AnyEncodable.swift
//  Hyxpro-fitness-app
//
//  Created by Satyam on 08/07/25.
//

import Foundation

struct AnyEncodable: Encodable {
    private let encode: (Encoder) throws -> Void

    init<T: Encodable>(_ value: T) {
        self.encode = value.encode
    }

    func encode(to encoder: Encoder) throws {
        try encode(encoder)
    }
}
