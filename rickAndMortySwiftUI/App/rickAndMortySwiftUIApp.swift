//
//  rickAndMortySwiftUIApp.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import SwiftUI

@main
struct rickAndMortySwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            AppFactory.makeCharactersView()
        }
    }
}

struct AppFactory {
    static func makeCharactersView() -> CharactersView {
        let service = CharactersService()
        let repository = CharactersRepository(service: service)
        return CharactersView(repository: repository)
    }
}
