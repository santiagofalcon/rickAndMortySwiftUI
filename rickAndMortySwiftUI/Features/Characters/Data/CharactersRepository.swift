//
//  CharactersRepository.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation

protocol CharactersRepositoryProtocol {
    func getCharacters(page: Int, query: String?) async throws -> CharactersResponse
    func fetchByURL(_ fullURL: String) async throws -> CharactersResponse
}

final class CharactersRepository: CharactersRepositoryProtocol {

    private let service: CharactersServiceProtocol
    
    init(service: CharactersServiceProtocol) {
        self.service = service
    }
    
    func getCharacters(page: Int, query: String?) async throws -> CharactersResponse {
        try await service.fetchCharacters(page: page, query: query)
    }

    func fetchByURL(_ fullURL: String) async throws -> CharactersResponse {
        try await service.fetchCharacters(fullURL: fullURL)
    }
}


