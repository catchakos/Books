//
//  DependenciesInterface.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

protocol DependenciesInterface {
    var persistency: PersistencyInterface { get set }
    var router: Routing? { get set }
    var apiClient: APIClientInterface { get set }
}
