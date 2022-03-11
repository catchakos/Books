//
//  ListInteractor.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ListBusinessLogic {
    func doSomething(_ request: List.Something.Request)
}

protocol ListDataStore: DependentStore {
}

class ListInteractor: ListBusinessLogic, ListDataStore {
    var dependencies: DependenciesInterface?
    var presenter: ListPresentationLogic?
    
    // MARK: Do something
    
    func doSomething(_ request: List.Something.Request) {
        let response = List.Something.Response()
        presenter?.presentSomething(response)
    }
}
