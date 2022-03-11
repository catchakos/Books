//
//  ListPresenter.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ListPresentationLogic {
    func presentSomething(_ response: List.Something.Response)
}

class ListPresenter: ListPresentationLogic {
    weak var viewController: ListDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(_ response: List.Something.Response) {
        let viewModel = List.Something.ViewModel()
        viewController?.displaySomething(viewModel)
    }
}
