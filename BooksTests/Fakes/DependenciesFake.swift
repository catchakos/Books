//
//  DependenciesFake.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Foundation
@testable import Books

class DependenciesFake: DependenciesInterface {
    func make(completion: @escaping (() -> Void)) {
        completion()
    }
    
    var persistency: PersistencyInterface? = PersistencyFake(completion: {})
    var router: Routing?
    var apiClient: APIClientInterface?
}

class PersistencyFake: PersistencyInterface {
    func startListeningToBooks(updateHandler: @escaping (() -> Void)) {
        
    }
    
    func stopListeningToBooks() {
        
    }
    
    func persist(book: Book) -> Bool {
        return true
    }
    
    func persistedBook(id: String) -> Book? {
        return nil
    }
    
    required init(completion: @escaping (() -> Void)) {
        
    }
}
