//
//  BookDetailVM.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import Foundation

class BookDetailVM: ObservableObject {
    @Published var details: ListItem

    init(bookDetails: ListItem) {
        details = bookDetails
    }
}
