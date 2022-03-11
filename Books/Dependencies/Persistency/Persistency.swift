//
//  Persistency.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

class Persistency: PersistencyInterface {
    func startListeningToBooks(updateHandler: @escaping (() -> Void)) {
        
    }
    
    func stopListeningToBooks() {
        
    }
    
    func persistBook() {
        
    }
    
    required init(completion: @escaping (() -> Void)) {
        completion()
    }
}
