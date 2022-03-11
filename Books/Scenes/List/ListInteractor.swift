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
}

class ListInteractor: ListBusinessLogic, ListDataStore {
    var dependencies: DependenciesInterface?
    var presenter: ListPresentationLogic?
    
    // MARK: Load
    
    func loadList(_ request: List.Load.Request) {
        let response = List.Load.Response(books: [])
        presenter?.presentLoad(response)
    }
    
    // MARK: Clear
    
    func clearList(_ request: List.Clear.Request) {
        let response = List.Clear.Response()
        presenter?.presentClear(response)
    }
    
    // MARK: Select Item
    
    func selectListItem(_ request: List.Select.Request) {
        let response = List.Select.Response(book: nil)
        presenter?.presentItemSelect(response)
    }
    
    // MARK: Add
    
    func addItem(_ request: List.Add.Request) {
        let response = List.Add.Response(book: nil)
        presenter?.presentAddItem(response)
    }
}
