//
//  PersistencyInterface.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

protocol PersistencyInterface: Dependency {
    func startListeningToBooks(updateHandler: @escaping ((/*[Book]*/) -> Void))
    func stopListeningToBooks()

    func persistBook() // -> Book?
}
