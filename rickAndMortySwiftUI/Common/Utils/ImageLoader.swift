//
//  ImageLoader.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 18/11/25.
//

import Foundation
import SwiftUI

actor ImageCache {
    static let shared = ImageCache()
    private var cache: [URL: Image] = [:]

    func image(for url: URL) -> Image? {
        cache[url]
    }

    func insert(_ image: Image, for url: URL) {
        cache[url] = image
    }
}

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: Image?
    private var url: URL?

    func load(from url: URL) {
        self.url = url

        Task {
            if let cached = await ImageCache.shared.image(for: url) {
                self.image = cached
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    let img = Image(uiImage: uiImage)
                    self.image = img
                    await ImageCache.shared.insert(img, for: url)
                }
            } catch {
                print("Image load error: \(error)")
            }
        }
    }
}
