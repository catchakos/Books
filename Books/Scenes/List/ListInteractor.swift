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
}

protocol ListDataStore: DependentStore {
    var listItems: ListItems { get }
    var selectedItem: ListItem? { get }
    var dateRequested: Date? { get }
}

class ListInteractor: ListBusinessLogic, ListDataStore {
    var dependencies: DependenciesInterface?
    var presenter: ListPresentationLogic?

    var isLoading = false

    var listItems: ListItems = []
    var selectedItem: ListItem?
    var dateRequested: Date?

    lazy var worker: BooksWorkerProtocol = BooksWorker(
        store: BooksAPIStore(apiClient: dependencies!.apiClient!),
        persistency: dependencies!.persistency!
    )

    // MARK: Load

    func loadList(_ request: List.Load.Request) {
        guard !isLoading else {
            return
        }

        dateRequested = request.date
        isLoading = true
        
        worker.fetchBooksList(
            date: request.date) { result in
                self.isLoading = false
                
                let response: List.Load.Response
                switch result {
                case let .success(items):
                    self.listItems = items
                    response = List.Load.Response(date: request.date, books: items, error: nil)
                case let .failure(error):
                    self.listItems = []
                    response = List.Load.Response(date: request.date, books: nil, error: error)
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
        let itemIndex = request.indexPath.row
        guard listItems.count > itemIndex else
        {
            selectedItem = nil
            return
        }
        
        let item = listItems[itemIndex]
        selectedItem = item
        
        let response = List.Select.Response(book: selectedItem)
        presenter?.presentItemSelect(response)
    }
}
