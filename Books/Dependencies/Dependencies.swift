//
//  Dependencies.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

class Dependencies: DependenciesInterface {
    var persistency: PersistencyInterface
    var apiClient: APIClientInterface
    weak var router: Routing?
    
    init(persistency: PersistencyInterface, apiClient: APIClientInterface, router: Routing?) {
        self.persistency = persistency
        self.apiClient = apiClient
        self.router = router
    }
}
