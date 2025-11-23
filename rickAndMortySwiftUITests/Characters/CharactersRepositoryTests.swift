//
//  CharactersRepositoryTests.swift
//  rickAndMortySwiftUITests
//
//  Created by Santiago Falcon Gonzalez on 23/11/25.
//

import XCTest
@testable import rickAndMortySwiftUI

final class CharactersRepositoryTests: XCTestCase {

    func testRepositoryLoadsData() async throws {
        let mock = MockCharactersService()
        let dummy = Character(
            id: 1,
            name: "Rick",
            status: .alive,
            species: .human,
            type: "",
            gender: .male,
            origin: Location(name: "", url: ""),
            location: Location(name: "", url: ""),
            image: "",
            episode: [],
            url: "",
            created: ""
        )

        mock.responseToReturn = CharactersResponse(
            info: Info(count: 1, pages: 1, next: nil, prev: nil),
            results: [dummy]
        )

        let repo = CharactersRepository(service: mock)
        let result = try await repo.getCharacters(page: 1, query: nil)

        XCTAssertEqual(result.results.count, 1)
        XCTAssertEqual(result.results.first?.name, "Rick")
    }

    func testRepositoryUsesFullURL() async throws {
        let mock = MockCharactersService()
        mock.responseToReturn = CharactersResponse(
            info: Info(count: 1, pages: 1, next: nil, prev: nil),
            results: []
        )

        let repo = CharactersRepository(service: mock)

        let fullURL = "https://rickandmortyapi.com/api/character?page=20"
        let _ = try await repo.fetchByURL(fullURL)

        XCTAssertEqual(mock.lastFullURL, fullURL)
    }
}
