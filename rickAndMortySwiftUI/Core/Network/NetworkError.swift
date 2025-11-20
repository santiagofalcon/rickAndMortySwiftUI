//
//  NetworkError.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 17/11/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidStatusCode
    case decodingFailed
    case noInternet
    case serverError(code: Int)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidStatusCode:
            return "The server returned an invalid response."
        case .decodingFailed:
            return "Failed to decode server data."
        case .noInternet:
            return "No internet connection."
        case .serverError(let code):
            return "Server error (\(code))."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}

