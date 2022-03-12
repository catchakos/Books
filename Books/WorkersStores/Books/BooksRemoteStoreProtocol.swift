//
//  BooksStoreProtocol.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Foundation

protocol BooksRemoteStoreProtocol {
    func fetchBooksList(offset: Int, count: Int, completion: @escaping ((Result<ListItems, Error>) -> Void))
    func fetchBookDetail(id: String, completion: @escaping ((Result<ItemDetails, Error>) -> Void))
    func postRandomBook(completion: @escaping ((Result<Book, Error>) -> Void))
}
