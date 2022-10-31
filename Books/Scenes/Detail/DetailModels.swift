//
//  DetailModels.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Detail {
    // MARK: Use cases

    enum Load {
        struct Request {}

        struct Response {
            let book: Book?
            let error: BooksError?
        }

        struct ViewModel {
            let title: String?
            let author: String?
            let imageUrl: URL?
            let errorMessage: String?
            let publisher: String?
            let isbn: String?
            let descriptionText: String?
        }
    }

    enum Preview {
        struct Request {}

        struct Response {
            let hasPreview: Bool
        }

        struct ViewModel {
            let hasPreview: Bool
        }
    }
}
