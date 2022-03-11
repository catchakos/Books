//
//  ListPresenter.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ListPresentationLogic {
    func presentLoad(_ request: List.Load.Response)
    func presentClear(_ request: List.Clear.Response)
    func presentItemSelect(_ request: List.Select.Response)
    func presentAddItem(_ request: List.Add.Response)
}

class ListPresenter: ListPresentationLogic {
    weak var viewController: ListDisplayLogic?
    
    // MARK: Load
    
    func presentLoad(_ request: List.Load.Response) {
        let vm = List.Load.ViewModel(books: [])
        viewController?.displayLoad(vm)
    }
    
    // MARK: Clear
    
    func presentClear(_ request: List.Clear.Response) {
        let vm = List.Clear.ViewModel()
        viewController?.displayClear(vm)
    }
    
    // MARK: Select
    
    func presentItemSelect(_ request: List.Select.Response) {
        // persist
        // post
        let vm = List.Select.ViewModel(success: true)
        viewController?.displaySelectListItem(vm)
    }
    
    // MARK: Add
    
    func presentAddItem(_ request: List.Add.Response) {
        let vm = List.Add.ViewModel(success: true)
        viewController?.displayAddListItem(vm)
    }
}
