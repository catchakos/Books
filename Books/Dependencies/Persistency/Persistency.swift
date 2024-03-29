//
//  Persistency.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

class Persistency: PersistencyInterface {
    required init(completion: @escaping (() -> Void)) {
        completion()
    }

    func startListeningToBooks(updateHandler _: @escaping (() -> Void)) {}

    func stopListeningToBooks() {}

    func persist(book _: Book) -> Bool {
        return true
    }

    func persistedBook(id _: String) -> Book? {
        return nil
    }
}
