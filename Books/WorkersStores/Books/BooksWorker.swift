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

    func fetchBooksList(offset: Int, count: Int, completion: @escaping ((Result<ListItems, BooksError>) -> Void)) {
        store.fetchBooksList(offset: offset, count: count) { result in
            switch result {
            case let .success(items):
                completion(.success(items))
            case let .failure(error):
                if let apiError = error as? APIClientError {
                    switch apiError {
                    case .cannotMakeUrl, .other:
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
                completion(.failure(self.booksError(from: error)))
            }
        }
    }
    
    func fetchBookPreviewURL(isbn: String, completion: @escaping ((Result<String, BooksError>) -> Void)) {
        store.fetchBookPreviewInfo(isbn: isbn) { result in
            switch result {
            case .success(let info):
                // TODO:
                if info.previewType == "" {
                    
                }
                print(info.previewType)
                completion(.success(info.previewURL))
            case .failure(let error):
                completion(.failure(self.booksError(from: error)))
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
    
    private func booksError(from error: Error) -> BooksError {
        if let apiError = error as? APIClientError {
            switch apiError {
            case .cannotMakeUrl, .other:
                return .cannotFetch
            case .decodeError, .parsing:
                return .cannotParse
            case .emptyResponse:
                return .notFound
            }
        } else {
            return .other
        }
    }
}
