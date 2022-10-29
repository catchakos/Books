//
//  BooksStoreProtocol.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Foundation

protocol BooksRemoteStoreProtocol {
    func fetchBooksList(date: Date, completion: @escaping ((Result<ListItems, Error>) -> Void))
    func fetchBookPreviewInfo(isbn: String, completion: @escaping ((Result<PreviewInfo, Error>) -> Void))
}
