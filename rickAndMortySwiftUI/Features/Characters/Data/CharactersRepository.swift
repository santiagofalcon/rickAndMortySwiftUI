//
//  CharactersRepository.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation

protocol CharactersRepositoryProtocol {
    func getCharacters(page: Int, query: String?) async throws -> [Character]
}

final class CharactersRepository {
    private let service: CharactersServiceProtocol
    
    init(service: CharactersServiceProtocol) {
        self.service = service
    }
    
    func getCharacters(page: Int, query: String?) async throws -> CharactersResponse {
        try await service.fetchCharacters(page: page, query: query)
    }
}


