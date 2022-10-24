//
//  SplashViewController.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SplashDisplayLogic: AnyObject {
    func displaySomething(_ viewModel: Splash.Something.ViewModel)
}

class SplashViewController: UIViewController, SplashDisplayLogic, DependentViewController {
    var dataStore: DependentStore {
        return router.dataStore
    }

    var interactor: SplashBusinessLogic
    var router: (NSObjectProtocol & SplashRoutingLogic & SplashDataPassing)

    // MARK: Object lifecycle

    required init(dependencies: DependenciesInterface) {
        let presenter = SplashPresenter()
        let interactorAndDataStore = SplashInteractor(dependencies: dependencies, presenter: presenter)
        let router = SplashRouter(dataStore: interactorAndDataStore)
        self.interactor = interactorAndDataStore
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
        
        presenter.viewController = self
        router.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()

        doSomething()
    }

    private func setupView() {}

    private func setupConstraints() {}

    // MARK:

    func doSomething() {
        let request = Splash.Something.Request()
        interactor.doSomething(request)
    }

    func displaySomething(_: Splash.Something.ViewModel) {}
}
