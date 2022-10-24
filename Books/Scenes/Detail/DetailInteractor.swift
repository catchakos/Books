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
}

protocol DetailDataStore: DependentStore {
    var listItem: ListItem? { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {
    var dependencies: DependenciesInterface
    var presenter: DetailPresentationLogic

    var listItem: ListItem?

    lazy var worker: BooksWorkerProtocol = BooksWorker(store: BooksFakeryStore(), persistency: dependencies.persistency!)

    // MARK: Init
    
    init(dependencies: DependenciesInterface, presenter: DetailPresentationLogic) {
        self.dependencies = dependencies
        self.presenter = presenter
    }
    
    // MARK: Do Load

    func doLoad(_: Detail.Load.Request) {
        guard let listItem = listItem else {
            return
        }

        worker.fetchBookDetail(id: listItem.id) { result in
            let response: Detail.Load.Response
            switch result {
            case let .success(book):
                let finalBook = self.book(from: listItem, detailItem: book)
                response = Detail.Load.Response(book: finalBook, error: nil)
            case let .failure(error):
                response = Detail.Load.Response(book: nil, error: error)
            }
            self.presenter.presentLoad(response)
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
