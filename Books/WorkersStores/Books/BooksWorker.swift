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

    func fetchBooksList(date: Date, completion: @escaping ((Result<ListItems, BooksError>) -> Void)) {
        store.fetchBooksList(date: date) { result in
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

    func fetchBookPreviewURL(isbn: String, completion: @escaping ((Result<String, BooksError>) -> Void)) {
        store.fetchBookPreviewInfo(isbn: isbn) { result in
            switch result {
            case .success(let info):
                if info.previewType == "noview" {
                    completion(.failure(.notFound))
                } else {
                    completion(.success(info.previewURL))
                }
                
            case .failure(let error):
                completion(.failure(self.booksError(from: error)))
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
