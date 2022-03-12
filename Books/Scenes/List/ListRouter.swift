//
//  ListRouter.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol ListRoutingLogic {
    func routeToDetail()
}

protocol ListDataPassing {
    var dataStore: ListDataStore? { get }
}

class ListRouter: NSObject, ListRoutingLogic, ListDataPassing {
    weak var viewController: ListViewController?
    var dataStore: ListDataStore?
    
    // MARK: Routing
    
    func routeToDetail() {
        let destinationVC = DetailViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToDetail(source: dataStore!, destination: &destinationDS)
        navigateToDetail(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToDetail(source: ListViewController, destination: DetailViewController) {
        destination.modalPresentationStyle = .overCurrentContext
        destination.transitioningDelegate = self
        viewController?.present(destination, animated: true, completion: nil)
    }
    
    // MARK: Passing data
    
    func passDataToDetail(source: ListDataStore, destination: inout DetailDataStore) {

    }
}

extension ListRouter: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
