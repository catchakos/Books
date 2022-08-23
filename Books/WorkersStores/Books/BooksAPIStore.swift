//
//  BooksAPIStore.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Foundation

class BooksAPIStore: BooksRemoteStoreProtocol {
    private var apiClient: APIClientInterface
    
    init(apiClient: APIClientInterface) {
        self.apiClient = apiClient
    }
    
    func fetchBooksList(offset _: Int, count _: Int, completion: @escaping ((Result<ListItems, Error>) -> Void)) {
        let endpoint = NYTimesBooksListEndpoint()
        _ = apiClient.fetch(
            endpoint: endpoint,
            responseType: NYTimesBooksList.self) { result in
                switch result {
                case let .success(booksList):
                    let itemsList = NYTimesBooksAdaptor.toListItems(booksList)
                    completion(.success(itemsList))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }

    func fetchBookDetail(id _: String, completion _: @escaping ((Result<ItemDetails, Error>) -> Void)) {}

    func postRandomBook(completion _: @escaping ((Result<Book, Error>) -> Void)) {}
}
