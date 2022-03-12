//
//  DetailViewController.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DetailDisplayLogic: AnyObject {
    func displaySomething(_ viewModel: Detail.Something.ViewModel)
}

class DetailViewController: UIViewController, DetailDisplayLogic, DependentViewController {
    var dataStore: DependentStore? {
        return router?.dataStore
    }

    var interactor: DetailBusinessLogic?
    var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?
    
    lazy var dimmedView: UIView = {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)

        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 30

        return view
    }()
    
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
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailRouter()
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
        setupBackgroundTap()
        
        doSomething()
    }
    
    private func setupView() {
        [dimmedView, contentView].forEach({
            view.addSubview($0)
        })
    }
    
    private func setupConstraints() {
        dimmedView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    private func setupBackgroundTap() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didTap(_:)))
        dimmedView.addGestureRecognizer(tap)
    }
    
    // MARK:
    
    func doSomething() {
        let request = Detail.Something.Request()
        interactor?.doSomething(request)
    }
    
    func displaySomething(_ viewModel: Detail.Something.ViewModel) {
        
    }
    
    @objc func didTap(_ tap: UITapGestureRecognizer) {
        router?.exitDetail()
    }
}

extension DetailViewController: CustomPresentedViewController {
    var containerViewForCustomPresentation: UIView {
        return contentView
    }
    
    var backgroundViewForCustomPresentation: UIView {
        return dimmedView
    }
}
