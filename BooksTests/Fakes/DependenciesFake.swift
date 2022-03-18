//
//  DependenciesFake.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

@testable import Books
import Foundation

class DependenciesFake: DependenciesInterface {
    func make(completion: @escaping (() -> Void)) {
        completion()
    }

    var persistency: PersistencyInterface? = PersistencyFake(completion: {})
    var router: Routing?
    var apiClient: APIClientInterface?
}

class PersistencyFake: PersistencyInterface {
    func startListeningToBooks(updateHandler _: @escaping (() -> Void)) {}

    func stopListeningToBooks() {}

    func persist(book _: Book) -> Bool {
        return true
    }

    func persistedBook(id _: String) -> Book? {
        return nil
    }

    required init(completion _: @escaping (() -> Void)) {}
}
