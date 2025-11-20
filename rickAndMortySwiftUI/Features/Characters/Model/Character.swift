//
//  Character.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: Status
    let species: Species
    let type: String
    let gender: Gender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

