//
//  BooksWorker.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Foundation

class BooksWorker: BooksWorkerProtocol {
   
    private var store: BooksRemoteStoreProtocol
    private var persistency: PersistencyInterface
    
    init(store: BooksRemoteStoreProtocol, persistency: PersistencyInterface) {
        self.store = store
        self.persistency = persistency
    }

    func fetchBooksList(offset: Int, count: Int, completion: @escaping ((Result<ListItem, BooksError>) -> Void)) {
        store.fetchBooksList(offset: offset, count: count) { result in
            switch result {
            case let .success(item):
                completion(.success(item))
            case let .failure(error):
                if let apiError = error as? APIClientError {
                    switch apiError {
                    case .cannotMakeUrl , .other:
                        completion(.failure(.cannotFetch))
                    case .decodeError, .parsing:
                        completion(.failure(.cannotParse))
                    case .emptyResponse:
                        completion(.failure(.notFound))
                    }
                } else {
                    completion(.failure(.other))
                }
            }
        }
    }
    
    func fetchBookDetail(id: String, completion: @escaping ((Result<Book, BooksError>) -> Void)) {
        store.fetchBookDetail(id: id) { result in
            switch result {
            case let .success(details):
                let book: Book = details
                if self.persistency.persist(book: book) {
                    completion(.success(book))
                } else {
                    completion(.failure(.cannotPersist))
                }
            case let .failure(error):
                if let apiError = error as? APIClientError {
                    switch apiError {
                    case .cannotMakeUrl , .other:
                        completion(.failure(.cannotFetch))
                    case .decodeError, .parsing:
                        completion(.failure(.cannotParse))
                    case .emptyResponse:
                        completion(.failure(.notFound))
                    }
                } else {
                    completion(.failure(.other))
                }
            }
        }
    }
    
    func addRandomBook(completion: @escaping ((Result<ItemDetails, BooksError>) -> Void)) {
        store.postRandomBook { result in
            switch result {
            case let .success(book):
                if self.persistency.persist(book: book) {
                    completion(.success(book))
                } else {
                    completion(.failure(.cannotPersist))
                }
            case .failure:
                completion(.failure(.other))
            }
        }
    }
    
}
