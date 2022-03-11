//
//  DetailInteractor.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DetailBusinessLogic {
    func doSomething(_ request: Detail.Something.Request)
}

protocol DetailDataStore: DependentStore {
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {
    var dependencies: DependenciesInterface?
    var presenter: DetailPresentationLogic?
    
    // MARK: Do something
    
    func doSomething(_ request: Detail.Something.Request) {
        let response = Detail.Something.Response()
        presenter?.presentSomething(response)
    }
}
