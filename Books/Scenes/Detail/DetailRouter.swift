//
//  DetailRouter.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import SafariServices
import UIKit

@objc protocol DetailRoutingLogic {
    func exitDetail()
    func routeToPreview()
}

protocol DetailDataPassing {
    var dataStore: DetailDataStore { get }
}

class DetailRouter: NSObject, DetailRoutingLogic, DetailDataPassing {
    weak var viewController: DetailViewController?
    var dataStore: DetailDataStore

    init(dataStore: DetailDataStore) {
        self.dataStore = dataStore
    } // MARK: Routing

    func exitDetail() {
        viewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func routeToPreview() {
        guard let urlString = dataStore.previewURLString,
              let url = URL(string: urlString) else
        {
            return
        }

        let safari = SFSafariViewController(url: url)
        viewController?.present(safari, animated: true)
    }
}
