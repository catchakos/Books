//
//  Dependencies.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

class Dependencies: DependenciesInterface {
    var persistency: PersistencyInterface?
    var apiClient: APIClientInterface?
    weak var router: Routing?

    func make(completion: @escaping (() -> Void)) {
        let group = DispatchGroup()

        group.enter()
        persistency = Persistency(completion: {
            group.leave()
        })
        
        group.enter()
        apiClient = FakeAPIClient(completion: {
            group.leave()
        })

        group.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
}
