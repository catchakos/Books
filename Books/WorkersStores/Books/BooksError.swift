//
//  BooksError.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Foundation

enum BooksError: Error {
    case cannotFetch
    case cannotParse
    case cannotCreate
    case cannotPersist
    case notFound
    case other
}
