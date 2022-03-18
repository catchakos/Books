//
//  BooksAPIStore.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Foundation

class BooksAPIStore: BooksRemoteStoreProtocol {
    func fetchBooksList(offset _: Int, count _: Int, completion _: @escaping ((Result<ListItems, Error>) -> Void)) {}

    func fetchBookDetail(id _: String, completion _: @escaping ((Result<ItemDetails, Error>) -> Void)) {}

    func postRandomBook(completion _: @escaping ((Result<Book, Error>) -> Void)) {}
}
