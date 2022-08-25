//
//  BooksError.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Foundation

enum BooksError: LocalizedError {
    case cannotFetch
    case cannotParse
    case cannotCreate
    case cannotPersist
    case notFound
    case other
}

extension BooksError {
    var errorDescription: String? {
        return localizedDescription
    }

    var localizedDescription: String? {
        return NSLocalizedString("Oooops...", comment: "")
    }
}
