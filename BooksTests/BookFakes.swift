//
//  BookFakes.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Foundation
@testable import Books

struct BookFakes {
    static let fakeBook1 = Book(
        id: "12",
        image: nil,
        title: "Book title",
        author: "Author",
        price: 4.99
    )
    
    static let fakeListItem1 = ListItem(
        id: "12",
        link: "www.link.com",
        title: "Book title")
}
