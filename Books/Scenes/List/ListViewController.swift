//
//  ListViewController.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ListDisplayLogic: AnyObject {
    func displaySomething(_ viewModel: List.Something.ViewModel)
}

class ListViewController: UIViewController, ListDisplayLogic, DependentViewController {
    var dataStore: DependentStore? {
        return router?.dataStore
    }

    var interactor: ListBusinessLogic?
    var router: (NSObjectProtocol & ListRoutingLogic & ListDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ListInteractor()
        let presenter = ListPresenter()
        let router = ListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupView()
        setupConstraints()
        
        doSomething()
    }
    
    private func setupView() {
        view.backgroundColor = .yellow
    }
    
    private func setupConstraints() {
        
    }
    
    // MARK:
        
    func doSomething() {
        let request = List.Something.Request()
        interactor?.doSomething(request)
    }
    
    func displaySomething(_ viewModel: List.Something.ViewModel) {
    
    }
}
