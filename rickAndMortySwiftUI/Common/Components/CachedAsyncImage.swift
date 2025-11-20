//
//  CachedAsyncImage.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 18/11/25.
//

import Foundation
import SwiftUI

struct CachedAsyncImage: View {
    @StateObject private var loader = ImageLoader()
    let url: URL
    let placeholder: () -> AnyView

    init(url: URL, @ViewBuilder placeholder: @escaping () -> AnyView = { AnyView(ProgressView()) }) {
        self.url = url
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let image = loader.image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder()
            }
        }
        .onAppear {
            loader.load(from: url)
        }
    }
}
