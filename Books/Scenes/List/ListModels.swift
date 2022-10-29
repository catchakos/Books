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
            let date: Date
        }

        struct Response {
            let date: Date
            let books: ListItems?
            let error: BooksError?
        }

        struct ViewModel {
            let dateText: String
            let books: ListItems
            let errorMessage: String?
        }
    }

    enum Clear {
        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum Select {
        struct Request {
            let indexPath: IndexPath
        }

        struct Response {
            let book: ListItem?
        }

        struct ViewModel {
            let success: Bool
        }
    }
}
