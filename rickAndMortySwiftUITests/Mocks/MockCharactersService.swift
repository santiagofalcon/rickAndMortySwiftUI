//
//  MockCharactersService.swift
//  rickAndMortySwiftUITests
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation
@testable import rickAndMortySwiftUI

final class MockCharactersService: CharactersServiceProtocol {

    var responseToReturn: CharactersResponse?
    var shouldThrowError = false
    var lastReceivedQuery: String?

    func fetchCharacters(page: Int, query: String? = nil) async throws -> CharactersResponse {
        lastReceivedQuery = query
        if shouldThrowError {
            throw NetworkError.decodingFailed
        }
        guard let response = responseToReturn else {
            fatalError("MockCharactersService: no responseToReturn set")
        }
        return response
    }
}

