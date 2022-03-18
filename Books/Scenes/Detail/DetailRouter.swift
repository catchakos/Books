//
//  DetailRouter.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol DetailRoutingLogic {
    func exitDetail()
}

protocol DetailDataPassing {
    var dataStore: DetailDataStore? { get }
}

class DetailRouter: NSObject, DetailRoutingLogic, DetailDataPassing {
    weak var viewController: DetailViewController?
    var dataStore: DetailDataStore?

    // MARK: Routing

    func exitDetail() {
        viewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Navigation

    // MARK: Passing data
}
