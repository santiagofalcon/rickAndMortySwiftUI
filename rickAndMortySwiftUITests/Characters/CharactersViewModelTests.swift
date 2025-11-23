//
//  CharactersViewModelTests.swift
//  rickAndMortySwiftUITests
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import XCTest
@testable import rickAndMortySwiftUI

final class CharactersViewModelTests: XCTestCase {

    // MARK: - Helpers

    func makeDummyCharacter(id: Int = 1) -> Character {
        Character(
            id: id,
            name: "Test \(id)",
            status: .alive,
            species: .human,
            type: "",
            gender: .male,
            origin: Location(name: "Earth", url: ""),
            location: Location(name: "Citadel", url: ""),
            image: "",
            episode: [],
            url: "",
            created: ""
        )
    }


    // MARK: - TESTS

    func testLoadCharactersSuccess() async {
        let mock = MockCharactersService()

        mock.responseToReturn = CharactersResponse(
            info: Info(count: 1, pages: 1, next: nil, prev: nil),
            results: [makeDummyCharacter()]
        )

        let repo = CharactersRepository(service: mock)
        let vm = await CharactersViewModel(repository: repo)

        await vm.loadCharacters()

        await MainActor.run {
            XCTAssertEqual(vm.characters.count, 1)
            XCTAssertNil(vm.lastError)
        }
    }

    func testLoadCharactersFailure() async {
        let mock = MockCharactersService()
        mock.shouldThrowError = true

        let repo = CharactersRepository(service: mock)
        let vm = await CharactersViewModel(repository: repo)

        await vm.loadCharacters()

        await MainActor.run {
            XCTAssertNotNil(vm.lastError)
            XCTAssertTrue(vm.characters.isEmpty)
        }
    }

    func testSearchQueryPassedToRepository() async {
        let mock = MockCharactersService()
        mock.responseToReturn = CharactersResponse(
            info: Info(count: 1, pages: 1, next: nil, prev: nil),
            results: []
        )

        let repo = CharactersRepository(service: mock)
        let vm = await CharactersViewModel(repository: repo)

        await vm.loadCharacters(query: "rick")

        XCTAssertEqual(mock.lastReceivedQuery, "rick")
    }

    func testPaginationLoadsNextPage() async {
        let mock = MockCharactersService()

        // page 1
        mock.responseToReturn = CharactersResponse(
            info: Info(count: 40, pages: 2, next: nil, prev: nil),
            results: (1...20).map { makeDummyCharacter(id: $0) }
        )

        // page 2
        mock.nextPageResponses = [
            CharactersResponse(
                info: Info(count: 40, pages: 2, next: nil, prev: nil),
                results: (21...40).map { makeDummyCharacter(id: $0) }
            )
        ]

        let repo = CharactersRepository(service: mock)
        let vm = await CharactersViewModel(repository: repo)

        await vm.loadCharacters()

        await vm.loadNextPageIfNeeded(currentItem: vm.characters[18])
        await MainActor.run {
            XCTAssertEqual(mock.callCount, 2)
            XCTAssertEqual(vm.characters.count, 40)
        }
    }

    func testNetworkErrorHandled() async {
        let mock = MockCharactersService()
        mock.shouldThrowError = true

        let repo = CharactersRepository(service: mock)
        let vm = await CharactersViewModel(repository: repo)

        await vm.loadCharacters()
        await MainActor.run {
            XCTAssertNotNil(vm.lastError)
        }
    }
}
