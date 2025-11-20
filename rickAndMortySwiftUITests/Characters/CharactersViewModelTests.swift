//
//  CharactersViewModelTests.swift
//  rickAndMortySwiftUITests
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation
import XCTest
@testable import rickAndMortySwiftUI

final class CharactersViewModelTests: XCTestCase {

    func testLoadCharactersSuccess() async {
        // GIVEN
        let mock = MockCharactersService()

        mock.responseToReturn = CharactersResponse(
            info: Info(count: 1, pages: 1, next: nil, prev: nil),
            results: [
                Character(
                    id: 1,
                    name: "Rick Sanchez",
                    status: .alive,
                    species: .human,
                    type: "",
                    gender: .male,
                    origin: Location(name: "Earth", url: ""),
                    location: Location(name: "Citadel", url: ""),
                    image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    episode: [],
                    url: "",
                    created: ""
                )
            ]
        )

        let repository = CharactersRepository(service: mock)
        let vm = await CharactersViewModel(repository: repository)

        // WHEN
        await vm.loadCharacters()

        // THEN (en el MainActor)
        await MainActor.run {
            XCTAssertEqual(vm.characters.count, 1)
            XCTAssertEqual(vm.characters.first?.name, "Rick Sanchez")
            XCTAssertNil(vm.errorMessage)
        }
    }

    func testLoadCharactersFailure() async {
        // GIVEN
        let mock = MockCharactersService()
        mock.shouldThrowError = true

        let repository = CharactersRepository(service: mock)
        let vm = await CharactersViewModel(repository: repository)

        // WHEN
        await vm.loadCharacters()

        // THEN (en el MainActor)
        await MainActor.run {
            XCTAssertTrue(vm.characters.isEmpty)
            XCTAssertNotNil(vm.errorMessage)
        }
    }
}
