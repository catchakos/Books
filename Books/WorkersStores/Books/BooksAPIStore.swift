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

    func fetchBooksList(date: Date, completion: @escaping ((Result<ListItems, Error>) -> Void)) {
        let endpoint = NYTimesBooksListEndpoint(date: date)
        _ = apiClient.fetch(
            endpoint: endpoint,
            responseType: NYTimesBooksList.self
        ) { result in
            switch result {
            case let .success(booksList):
                let itemsList = NYTimesBooksAdaptor.toListItems(booksList)
                completion(.success(itemsList))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func fetchBookPreviewInfo(isbn: String, completion: @escaping ((Result<PreviewInfo, Error>) -> Void)) {
        let endpoint = OpenLibraryReviewEndpoint(isbn: isbn)
        _ = apiClient.fetch(
            endpoint: endpoint,
            responseType: [String: PreviewInfo].self,
            completion: { result in
                switch result {
                case let .success(info):
                    if let previewInfo = info.values.first {
                        completion(.success(previewInfo))
                    } else {
                        completion(.failure(NSError(domain: "openLibraryResponseError", code: 500)))
                    }
                case let .failure(failure):
                    completion(.failure(failure))
                }
            }
        )
    }
}
