//
//  BookDetailVMFakes.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 24/8/22.
//

@testable import Books
import Foundation

struct BookDetailVMFakes {
    static let fakeNoButtons = BookDetailVM(bookDetails: ListItemFakes.fakeNoLinks)
    static let fakeAmazonAndReviewButtons = BookDetailVM(bookDetails: ListItemFakes.fakeBothLinks)
    static let fakeAmazonButton = BookDetailVM(bookDetails: ListItemFakes.fakeAmazonLink)
    static let fakeReviewButton = BookDetailVM(bookDetails: ListItemFakes.fakeReviewLink)
}

struct ListItemFakes {
    static let fakeNoLinks = ListItem(
        id: "1111",
        link: nil,
        title: "The title",
        author: "Author",
        bookDescription: "Toulouse, verano de 1939. Carmen de Pedro, responsable en Francia de los diezmados comunistas españoles, se cruza con Jesús Monzón, un ex cargo del partido que, sin ella intuirlo, alberga un ambicioso plan.",
        imageUrl: URL(string: "https://google.com"),
        publisher: "Publisher",
        primaryISBN10: "1234512345",
        amazonURL: "",
        reviewLink: "")
    
    static let fakeBothLinks = ListItem(
        id: "1111",
        link: nil,
        title: "The title",
        author: "Author",
        bookDescription: "Toulouse, verano de 1939. Carmen de Pedro, responsable en Francia de los diezmados comunistas españoles, se cruza con Jesús Monzón, un ex cargo del partido que, sin ella intuirlo, alberga un ambicioso plan.",
        imageUrl: URL(string: "https://google.com"),
        publisher: "Publisher",
        primaryISBN10: "1234512345",
        amazonURL: "http://www.amazon.com",
        reviewLink: "http://www.nytimes.com")
    
    static let fakeAmazonLink = ListItem(
        id: "1111",
        link: nil,
        title: "The title",
        author: "Author",
        bookDescription: "Toulouse, verano de 1939. Carmen de Pedro, responsable en Francia de los diezmados comunistas españoles, se cruza con Jesús Monzón, un ex cargo del partido que, sin ella intuirlo, alberga un ambicioso plan.",
        imageUrl: URL(string: "https://google.com"),
        publisher: "Publisher",
        primaryISBN10: "1234512345",
        amazonURL: "http://www.amazon.com",
        reviewLink: "")
    
    static let fakeReviewLink = ListItem(
        id: "1111",
        link: nil,
        title: "The title",
        author: "Author",
        bookDescription: "Toulouse, verano de 1939. Carmen de Pedro, responsable en Francia de los diezmados comunistas españoles, se cruza con Jesús Monzón, un ex cargo del partido que, sin ella intuirlo, alberga un ambicioso plan.",
        imageUrl: URL(string: "https://google.com"),
        publisher: "Publisher",
        primaryISBN10: "1234512345",
        amazonURL: "",
        reviewLink: "http://www.nytimes.com")
}
                                            
                                            
