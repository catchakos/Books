//
//  ListViewController.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import SnapKit
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

    // MARK: - UI Elements

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.accessibilityLabel = "list_table"
        return table
    }()

    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .red
        label.isHidden = true
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        label.accessibilityLabel = "error_label"
        return label
    }()

    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.accessibilityLabel = "spinner"
        return spinner
    }()

    // MARK: - Table Handler

    lazy var tableHandler: ListTableHandler = {
        let handler = ListTableHandler(table: tableView)
        handler.onSelection = { indexPath in
            self.selectListItem(indexPath)
        }
        handler.onScrolledToBottom = {
            self.loadList()
        }
        return handler
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
        setupNavigationItem()

        loadList()
    }

    private func setupView() {
        [tableView, errorLabel, spinner].forEach {
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }

        errorLabel.snp.makeConstraints { make in
            make.bottomMargin.equalToSuperview().offset(-8)
            make.leadingMargin.equalToSuperview().offset(32)
            make.trailingMargin.equalToSuperview().offset(-32)
        }

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupNavigationItem() {
        navigationItem.title = NSLocalizedString("Books", comment: "")

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
    }

    // MARK: - Load

    func loadList() {
        spinner.startAnimating()

        let request = List.Load.Request()
        interactor?.loadList(request)
    }

    func displayLoad(_ viewModel: List.Load.ViewModel) {
        tableHandler.add(newItems: viewModel.books)

        errorLabel.text = viewModel.errorMessage
        errorLabel.isHidden = viewModel.errorMessage == nil

        spinner.stopAnimating()
    }

    // MARK: - Clear

    func clearList() {
        let request = List.Clear.Request()
        interactor?.clearList(request)
    }

    func displayClear(_: List.Clear.ViewModel) {
        tableHandler.clear()
    }

    // MARK: - Select

    func selectListItem(_ indexPath: IndexPath) {
        let request = List.Select.Request(indexPath: indexPath)
        interactor?.selectListItem(request)
    }

    func displaySelectListItem(_ viewModel: List.Select.ViewModel) {
        guard viewModel.success else {
            return
        }

        router?.routeToDetail()
    }

    // MARK: Add

    @objc func didTapAdd() {
        addListItem()
    }

    func addListItem() {
        let request = List.Add.Request()
        interactor?.addItem(request)
    }

    func displayAddListItem(_ viewModel: List.Add.ViewModel) {
        errorLabel.text = viewModel.errorMessage
        errorLabel.isHidden = viewModel.errorMessage == nil
    }
}
