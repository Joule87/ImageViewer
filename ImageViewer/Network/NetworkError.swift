//
//  NetworkError.swift
//  ImageViewer
//
//  Created by Julio Collado on 31/7/21.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case error(errorDescription: String)
    case decodingError
    
    var customDescription: String {
        switch self {
        case .invalidResponse:
            return "invalid.response.error".localized
        case .invalidData:
            return "data.error".localized
        case .error(errorDescription: let errorDescription):
            return errorDescription
        case .decodingError:
            return "data.error".localized
        }
    }
}
