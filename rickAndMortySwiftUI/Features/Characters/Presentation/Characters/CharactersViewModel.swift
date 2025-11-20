//
//  CharactersViewModel.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation

@MainActor
final class CharactersViewModel: ObservableObject {

    @Published var characters: [Character] = []
    @Published var errorMessage: String?
    @Published var isLoadingMore = false
    @Published var isRefreshing = false
    @Published var searchText: String = ""
    @Published var lastError: NetworkError?

    private let repository: CharactersRepository
    
    private var currentPage = 1
    private var totalPages = 1
    private var currentQuery: String?

    init(repository: CharactersRepository) {
        self.repository = repository
    }

    func loadCharacters(query: String? = nil) async {
        errorMessage = nil
        isRefreshing = true
        currentQuery = query
        currentPage = 1
        
        
        do {
            let response = try await repository.getCharacters(page: currentPage, query: query)
            characters = response.results
            totalPages = response.info.pages
        } catch {
            if let netErr = error as? NetworkError {
                lastError = netErr
            } else {
                lastError = .unknown
            }
        }

        
        isRefreshing = false
    }

    func loadNextPageIfNeeded(currentItem item: Character) async {
        guard !isLoadingMore else { return }
        guard currentPage < totalPages else { return }
        
        // Si estamos en la penúltima celda → cargar más
        if let index = characters.firstIndex(where: { $0.id == item.id }),
           index >= characters.count - 2 {

            await loadMore()
        }
    }

    private func loadMore() async {
        isLoadingMore = true
        currentPage += 1

        do {
            let response = try await repository.getCharacters(page: currentPage, query: currentQuery)
            characters.append(contentsOf: response.results)
        } catch {
            if let netErr = error as? NetworkError {
                lastError = netErr
            } else {
                lastError = .unknown
            }
        }


        isLoadingMore = false
    }
}


