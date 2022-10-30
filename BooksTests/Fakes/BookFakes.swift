//
//  BookFakes.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

@testable import Books
import Foundation

struct BookFakes {
    static let fakeBook1 = fakeListItem1

    static let fakeListItem1 = ListItem(
        id: "12",
        link: "www.link.com",
        title: "Book title",
        author: "Author",
        bookDescription: "descrigdfgadf",
        imageUrl: nil,
        publisher: "Publisher",
        primaryISBN10: "123412341234",
        amazonURL: "",
        reviewLink: ""
    )

    static let fakeList1 = [fakeListItem1]
    static let fakeList2 = [makeFakeListItem(id: 2), makeFakeListItem(id: 3)]

    static let onePage = (0..<20).map({
        makeFakeListItem(id: $0)
    })
    
    static func makeFakeBook(id: Int) -> Book {
        return makeFakeListItem(id: id)
    }
    
    static func makeFakeListItem(id: Int) -> ListItem {
        return ListItem(
            id: String(id),
            link: "www.link.com",
            title: "Book title \(id)",
            author: "Author",
            bookDescription: "descrigdfgadf",
            imageUrl: nil,
            publisher: "Publisher",
            primaryISBN10: "123412341234",
            amazonURL: "",
            reviewLink: ""
        )
    }
}
