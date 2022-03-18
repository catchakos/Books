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
    var dataStore: DependentStore? {
        return router?.dataStore
    }

    var interactor: SplashBusinessLogic?
    var router: (NSObjectProtocol & SplashRoutingLogic & SplashDataPassing)?

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
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        let router = SplashRouter()
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

    private func setupView() {}

    private func setupConstraints() {}

    // MARK:

    func doSomething() {
        let request = Splash.Something.Request()
        interactor?.doSomething(request)
    }

    func displaySomething(_: Splash.Something.ViewModel) {}
}
