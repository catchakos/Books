//
//  ListInteractor.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ListBusinessLogic {
    func loadList(_ request: List.Load.Request)
    func clearList(_ request: List.Clear.Request)
    func selectListItem(_ request: List.Select.Request)
    func addItem(_ request: List.Add.Request)
}

protocol ListDataStore: DependentStore {
    var listItems: ListItems { get set }
    var selectedItem: ListItem? { get set }
}

class ListInteractor: ListBusinessLogic, ListDataStore {
    var dependencies: DependenciesInterface?
    var presenter: ListPresentationLogic?

    var offset: Int = 0
    var isLoading = false

    var listItems: ListItems = []
    var selectedItem: ListItem?

    enum Constants {
        static let pageSize = 20
    }

    lazy var worker: BooksWorkerProtocol = BooksWorker(
        store: BooksFakeryStore(),
        persistency: dependencies!.persistency!
    )

    // MARK: Load

    func loadList(_: List.Load.Request) {
        guard !isLoading else {
            return
        }

        isLoading = true
        worker.fetchBooksList(
            offset: offset,
            count: Constants.pageSize
        ) { result in
            self.isLoading = false

            let response: List.Load.Response
            switch result {
            case let .success(items):
                self.offset += Constants.pageSize
                self.listItems.append(contentsOf: items)

                response = List.Load.Response(books: items, error: nil)
            case let .failure(error):
                response = List.Load.Response(books: nil, error: error)
            }
            self.presenter?.presentLoad(response)
        }
    }

    // MARK: Clear

    func clearList(_: List.Clear.Request) {
        listItems.removeAll()

        let response = List.Clear.Response()
        presenter?.presentClear(response)
    }

    // MARK: Select Item

    func selectListItem(_ request: List.Select.Request) {
        let itemIndex = request.indexPath.item
        guard listItems.count > itemIndex else {
            selectedItem = nil
            return
        }

        let item = listItems[itemIndex]
        selectedItem = item

        let response = List.Select.Response(book: selectedItem)
        presenter?.presentItemSelect(response)
    }

    // MARK: Add

    func addItem(_: List.Add.Request) {
        worker.addRandomBook { result in
            let response: List.Add.Response
            switch result {
            case let .success(book):
                response = List.Add.Response(book: book)
            case .failure:
                response = List.Add.Response(book: nil)
            }
            self.presenter?.presentAddItem(response)
        }
    }
}
