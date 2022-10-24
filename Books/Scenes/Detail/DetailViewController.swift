//
//  DetailViewController.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DetailDisplayLogic: AnyObject {
    func displayLoad(_ viewModel: Detail.Load.ViewModel)
}

class DetailViewController: UIViewController, DetailDisplayLogic, DependentViewController {
    var dataStore: DependentStore {
        return router.dataStore
    }

    var interactor: DetailBusinessLogic
    var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)

    // MARK: - UI Elements

    lazy var dimmedView: UIView = {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)

        view.accessibilityLabel = "dimmed_view"

        return view
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 30

        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.accessibilityLabel = "title_label"
        return label
    }()

    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .black
        label.textAlignment = .center
        label.accessibilityLabel = "author_label"
        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right
        label.accessibilityLabel = "price_label"
        return label
    }()

    lazy var stack = UIStackView.vertical(
        with: [
            titleLabel,
            authorLabel,
            priceLabel
        ]
    )

    // MARK: Object lifecycle

    required init(dependencies: DependenciesInterface) {
        let presenter = DetailPresenter()
        let interactorAndDataStore = DetailInteractor(dependencies: dependencies, presenter: presenter)
        let router = DetailRouter(dataStore: interactorAndDataStore)
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
        setupBackgroundTap()

        doLoad()
    }

    private func setupView() {
        [dimmedView, contentView].forEach {
            view.addSubview($0)
        }

        contentView.addSubview(stack)
    }

    private func setupConstraints() {
        dimmedView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }

        stack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leadingMargin.trailingMargin.equalToSuperview()
        }
    }

    private func setupBackgroundTap() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didTap(_:)))
        dimmedView.addGestureRecognizer(tap)
    }

    // MARK:

    func doLoad() {
        let request = Detail.Load.Request()
        interactor.doLoad(request)
    }

    func displayLoad(_ viewModel: Detail.Load.ViewModel) {
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        priceLabel.text = viewModel.price
    }

    @objc func didTap(_: UITapGestureRecognizer) {
        router.exitDetail()
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
