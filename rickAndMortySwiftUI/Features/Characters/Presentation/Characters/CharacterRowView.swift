//
//  CharacterRowView.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation
import SwiftUICore
import SwiftUI

struct CharacterRowView: View {
    let character: Character

    var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: character.image)!) {
                AnyView(Color.gray.opacity(0.2))
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)

                Text(character.status.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
