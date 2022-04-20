//
//  BookFakes.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

@testable import Books
import Foundation

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
        title: "Book title"
    )

    static let fakeList1 = [fakeListItem1]
    static let fakeList2 = [makeFakeListItem(id: 2)]

    static let onePage = (0...ListInteractor.Constants.pageSize-1).map({
        makeFakeListItem(id: $0)
    })
    
    static func makeFakeBook(id: Int) -> Book {
        return Book(
            id: String(id),
            image: nil,
            title: "Book title \(id)",
            author: "Author",
            price: 4.99
        )
    }
    
    static func makeFakeListItem(id: Int) -> ListItem {
        return ListItem(
            id: String(id),
            link: "www.link.com",
            title: "Book title \(id)"
        )
    }
}
