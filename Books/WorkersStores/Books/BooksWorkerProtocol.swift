//
//  BooksWorkerProtocol.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Foundation

protocol BooksWorkerProtocol {
    func fetchBooksList(offset: Int, count: Int, completion: @escaping ((Result<ListItems, BooksError>) -> Void))
    func fetchBookDetail(id: String, completion: @escaping ((Result<Book, BooksError>) -> Void))
    func addRandomBook(completion: @escaping ((Result<Book, BooksError>) -> Void))
}
