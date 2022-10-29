//
//  DetailInteractor.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DetailBusinessLogic {
    func doLoad(_ request: Detail.Load.Request)
    func loadPreview(_ request: Detail.Preview.Request)
}

protocol DetailDataStore: DependentStore {
    var listItem: ListItem? { get set }
    var previewURLString: String? { get }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {
    var dependencies: DependenciesInterface?
    var presenter: DetailPresentationLogic?

    var listItem: ListItem?
    var previewURLString: String?

    lazy var worker: BooksWorkerProtocol = BooksWorker(
        store: BooksAPIStore(apiClient: dependencies!.apiClient!),
        persistency: dependencies!.persistency!
    )
    
    // MARK: Do Load

    func doLoad(_: Detail.Load.Request) {
        guard let listItem = listItem else {
            return
        }

        worker.fetchBookDetail(id: listItem.id) { [weak self] result in
            guard let self else {
                return
            }
            
            let response: Detail.Load.Response
            switch result {
            case let .success(book):
                let finalBook = self.book(from: listItem, detailItem: book)
                response = Detail.Load.Response(book: finalBook, error: nil)
            case let .failure(error):
                response = Detail.Load.Response(book: nil, error: error)
            }
            self.presenter?.presentLoad(response)
        }
    }
    
    // MARK: Load Preview

    func loadPreview(_ request: Detail.Preview.Request) {
        guard let listItem = listItem else {
            return
        }
        
        worker.fetchBookPreviewURL(isbn: listItem.primaryISBN10) { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case let .success(urlString):
                self.previewURLString = urlString
            case .failure:
                self.previewURLString = nil
            }
            
            let response = Detail.Preview.Response(hasPreview: self.previewURLString != nil)
            self.presenter?.presentPreview(response)
        }
    }
    
    // MARK: Aux

    func book(from listItem: ListItem, detailItem: Book) -> Book {
        return Book(
            id: listItem.id,
            image: detailItem.image,
            title: listItem.title,
            author: detailItem.author,
            price: detailItem.price
        )
    }
}
