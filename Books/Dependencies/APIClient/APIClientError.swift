//
//  APIClientError.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

enum APIClientError: Error {
    case emptyResponse
    case decodeError
    case cannotMakeUrl
    case parsing
    case other

    var message: String {
        return NSLocalizedString("Oooops...", comment: "")
    }
}
