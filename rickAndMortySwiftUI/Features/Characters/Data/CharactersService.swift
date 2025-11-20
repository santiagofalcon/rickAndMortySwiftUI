//
//  CharactersService.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation

protocol CharactersServiceProtocol {
    func fetchCharacters(page: Int, query: String?) async throws -> CharactersResponse
    func fetchCharacters(fullURL: String) async throws -> CharactersResponse
}



struct CharactersService: CharactersServiceProtocol {

    private let client: APIClientProtocol

    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }

    func fetchCharacters(page: Int, query: String? = nil) async throws -> CharactersResponse {
        try await client.fetch(
            CharactersResponse.self,
            from: Endpoint.characters(page: page, query: query).url
        )
    }
    
    func fetchCharacters(fullURL: String) async throws -> CharactersResponse {
        let url = URL(string: fullURL)!
        return try await client.fetch(CharactersResponse.self, from: url)
    }

}
