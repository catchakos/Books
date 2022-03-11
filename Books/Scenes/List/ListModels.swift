//
//  ListModels.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum List {
    // MARK: Use cases
    
    enum Load {
        struct Request {
        }
        struct Response {
            let books: Books
        }
        struct ViewModel {
            let books: Books
        }
    }
    
    enum Clear {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum Select {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let book: Book?
        }
        struct ViewModel {
            let success: Bool
        }
    }
    
    enum Add {
        struct Request {
        }
        struct Response {
            let book: Book?
        }
        struct ViewModel {
            let success: Bool
        }
    }
}
