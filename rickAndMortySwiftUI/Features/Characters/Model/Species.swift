//
//  Species.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation

enum Species: String, Codable {
    case human = "Human"
    case alien = "Alien"
    case unknown = "unknown"
    case other

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = (try? container.decode(String.self)) ?? ""
        self = Species(rawValue: value) ?? .other
    }
}
