//
//  ListViewController.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ListDisplayLogic: AnyObject {
    func displayLoad(_ viewModel: List.Load.ViewModel)
    func displayClear(_ viewModel: List.Clear.ViewModel)
    func displaySelectListItem(_ viewModel: List.Select.ViewModel)
    func displayAddListItem(_ viewModel: List.Add.ViewModel)
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
        
        loadList()
    }
    
    private func setupView() {
        view.backgroundColor = .yellow
    }
    
    private func setupConstraints() {
        
    }
    
    // MARK: - Load
        
    func loadList() {
        let request = List.Load.Request()
        interactor?.loadList(request)
    }
    
    func displayLoad(_ viewModel: List.Load.ViewModel) {
        
    }
    
    // MARK: - Clear
        
    func clearList() {
        let request = List.Clear.Request()
        interactor?.clearList(request)
    }
    
    func displayClear(_ viewModel: List.Clear.ViewModel) {
        
    }
    
    // MARK: - Select
        
    func selectListItem(_ indexPath: IndexPath) {
        let request = List.Select.Request(indexPath: indexPath)
        interactor?.selectListItem(request)
    }
    
    func displaySelectListItem(_ viewModel: List.Select.ViewModel) {
    
    }
    
    // MARK: Add
    
    func addListItem() {
        let request = List.Add.Request()
        interactor?.addItem(request)
    }
    
    func displayAddListItem(_ viewModel: List.Add.ViewModel) {
        
    }
}
