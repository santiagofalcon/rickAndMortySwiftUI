//
//  CharacterDetailView.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 18/11/25.
//

import Foundation
import SwiftUI

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                CachedAsyncImage(url: URL(string: character.image)!) {
                    AnyView(Color.gray.opacity(0.2))
                }
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Text(character.name)
                    .font(.largeTitle)
                    .bold()

                InfoRow(title: "Status", value: character.status.rawValue)
                InfoRow(title: "Species", value: character.species.rawValue)
                InfoRow(title: "Gender", value: character.gender.rawValue)
                InfoRow(title: "Origin", value: character.origin.name)
                InfoRow(title: "Location", value: character.location.name)

                Spacer()
            }
            .padding()
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title + ":")
                .font(.headline)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
