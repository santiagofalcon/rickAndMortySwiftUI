//
//  CharactersView.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import SwiftUICore
import SwiftUI

struct CharactersView: View {
    @StateObject private var vm: CharactersViewModel
    @State private var searchText = ""
    @State private var searchDebounceTask: Task<Void, Never>? = nil
    @State private var selectedCharacter: Character?
    @State private var toastMessage: String?

    init(repository: CharactersRepository) {
        _vm = StateObject(wrappedValue: CharactersViewModel(repository: repository))
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(vm.characters) { character in
                        CharacterRowView(character: character)
                            .onTapGesture {
                                selectedCharacter = character
                            }
                            .onAppear {
                                Task { await vm.loadNextPageIfNeeded(currentItem: character) }
                            }
                    }
                } header: {
                    SearchBar(text: $searchText)
                        .padding(.bottom, 8)
                        .onChange(of: searchText) { _, newValue in
                                    debounceSearch(text: newValue)
                                }
                }
                .headerProminence(.increased)
            }
            .listStyle(.plain)
            .sheet(item: $selectedCharacter) { character in
                CharacterDetailView(character: character)
            }
            .overlay(loadingMoreView, alignment: .bottom)
            .navigationTitle("Characters")
            .onReceive(vm.$lastError) { err in
                if let err {
                    toastMessage = err.localizedDescription
                }
            }
            .toast(message: $toastMessage)
            .task {
                await vm.loadCharacters()
            }
        }
    }

    @ViewBuilder
    var loadingMoreView: some View {
        if vm.isLoadingMore {
            ProgressView().padding()
        }
    }

    // MARK: - Debounce Search
    func debounceSearch(text: String) {
        searchDebounceTask?.cancel()

        searchDebounceTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000) 
            await vm.loadCharacters(query: text)
        }
    }
}
