//
//  MockCharactersService.swift
//  rickAndMortySwiftUITests
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation
@testable import rickAndMortySwiftUI

final class MockCharactersService: CharactersServiceProtocol {

    // MARK: - Configuration
    var responseToReturn: CharactersResponse?
    var nextPageResponses: [CharactersResponse] = []

    var shouldThrowError = false
    var lastReceivedQuery: String?
    var lastFullURL: String?

    var callCount = 0


    // MARK: - Pagination + query
    func fetchCharacters(page: Int, query: String?) async throws -> CharactersResponse {
        callCount += 1
        lastReceivedQuery = query
        if shouldThrowError {
            throw NetworkError.decodingFailed
        }

        if !nextPageResponses.isEmpty {
            return nextPageResponses.removeFirst()
        }

        guard let response = responseToReturn else {
            fatalError("MockCharactersService: no responseToReturn set")
        }

        return response
    }


    // MARK: - Full URL fetch
    func fetchCharacters(fullURL: String) async throws -> CharactersResponse {
        callCount += 1
        lastFullURL = fullURL

        if shouldThrowError {
            throw NetworkError.noInternet
        }

        guard let response = responseToReturn else {
            fatalError("MockCharactersService: no responseToReturn set")
        }

        return response
    }
}
