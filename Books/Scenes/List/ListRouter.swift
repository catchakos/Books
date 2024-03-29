//
//  ListRouter.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI
import UIKit

@objc protocol ListRoutingLogic {
    func routeToDetail()
}

protocol ListDataPassing {
    var dataStore: ListDataStore { get }
}

class ListRouter: NSObject, ListRoutingLogic, ListDataPassing {
    weak var viewController: ListViewController?
    var dataStore: ListDataStore

    private var useSwiftUIDetail = false

    init(dataStore: ListDataStore) {
        self.dataStore = dataStore
    }

    // MARK: Routing

    func routeToDetail() {
        if useSwiftUIDetail {
            routeToSwiftUIDetailView()
        } else {
            routeToDetailVC()
        }
    }

    private func routeToSwiftUIDetailView() {
        let bookDetailVC = UIHostingController(rootView: BookDetailView(
            viewModel: BookDetailVM(bookDetails: dataStore.selectedItem!),
            navigationController: viewController?.navigationController
        ))
        viewController?.navigationController?.pushViewController(bookDetailVC, animated: true)
    }

    private func routeToDetailVC() {
        let destinationVC = DetailViewController(dependencies: dataStore.dependencies)
        var destinationDS = destinationVC.router.dataStore
        passDataToDetail(source: dataStore, destination: &destinationDS)
        navigateToDetail(source: viewController!, destination: destinationVC)
    }

    // MARK: Navigation

    func navigateToDetail(source _: ListViewController, destination: DetailViewController) {
        destination.modalPresentationStyle = .overCurrentContext
        destination.transitioningDelegate = self
        viewController?.present(destination, animated: true, completion: nil)
    }

    // MARK: Passing data

    func passDataToDetail(source: ListDataStore, destination: inout DetailDataStore) {
        destination.dependencies = source.dependencies
        destination.listItem = source.selectedItem
    }
}

extension ListRouter: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented is DetailViewController {
            return BottomUpPresentation<DetailViewController>()
        }
        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is DetailViewController {
            return ToBottomDismissal<DetailViewController>()
        }
        return nil
    }
}
