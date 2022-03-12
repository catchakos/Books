//
//  ListPresenter.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ListPresentationLogic {
    func presentLoad(_ response: List.Load.Response)
    func presentClear(_ response: List.Clear.Response)
    func presentItemSelect(_ response: List.Select.Response)
    func presentAddItem(_ response: List.Add.Response)
}

class ListPresenter: ListPresentationLogic {
    weak var viewController: ListDisplayLogic?
    
    // MARK: Load
    
    func presentLoad(_ response: List.Load.Response) {
        let vm = List.Load.ViewModel(
            books: response.books ?? [],
            errorMessage: response.error?.localizedDescription)
        viewController?.displayLoad(vm)
    }
    
    // MARK: Clear
    
    func presentClear(_ response: List.Clear.Response) {
        let vm = List.Clear.ViewModel()
        viewController?.displayClear(vm)
    }
    
    // MARK: Select
    
    func presentItemSelect(_ response: List.Select.Response) {
        let vm = List.Select.ViewModel(success: response.book != nil)
        viewController?.displaySelectListItem(vm)
    }
    
    // MARK: Add
    
    func presentAddItem(_ response: List.Add.Response) {
        let vm = List.Add.ViewModel(
            success: response.book != nil,
            errorMessage: response.book == nil ? NSLocalizedString("Cannot create book", comment: "") : nil)
        viewController?.displayAddListItem(vm)
    }
}
