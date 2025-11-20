//
//  Endpoint.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation

enum Endpoint {
    case characters(page: Int = 1, query: String? = nil)

    var url: URL {
        switch self {
        case let .characters(page, query):
            let baseURL = "https://rickandmortyapi.com/api/character"
            var urlString = "\(baseURL)?page=\(page)"
            
            if let query, !query.isEmpty {
                let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
                urlString += "&name=\(encodedQuery)"
            }
            
            guard let url = URL(string: urlString) else {
                fatalError("Invalid URL: \(urlString)")
            }
            
            return url
        }
    }}

