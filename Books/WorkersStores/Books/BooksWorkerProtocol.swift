//
//  BooksWorkerProtocol.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Foundation

protocol BooksWorkerProtocol {
    func fetchBooksList(date: Date, completion: @escaping ((Result<ListItems, BooksError>) -> Void))
    func fetchBookPreviewURL(isbn: String, completion: @escaping ((Result<String, BooksError>) -> Void))
}
