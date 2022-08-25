//
//  APIClientError.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

enum APIClientError: LocalizedError {
    case emptyResponse
    case decodeError
    case cannotMakeUrl
    case parsing
    case other(Error)
}

extension APIClientError {
    var errorDescription: String? {
        return localizedDescription
    }

    var localizedDescription: String? {
        return NSLocalizedString("Oooops...", comment: "")
    }
}
