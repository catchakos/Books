//
//  NYTimesBooksAdaptor.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import Foundation

struct NYTimesBooksAdaptor {
    static func toListItems(_ booksList: NYTimesBooksList) -> ListItems {
        return booksList.results.books.compactMap {
            toListItem($0)
        }
    }

    static func toListItem(_ bookItem: NYTimesBooksListItem) -> ListItem {
        return ListItem(
            id: bookItem.primaryISBN10,
            link: bookItem.amazonURL,
            title: bookItem.title,
            author: bookItem.author,
            bookDescription: bookItem.bookDescription,
            imageUrl: URL(string: bookItem.bookImage),
            publisher: bookItem.publisher,
            primaryISBN10: bookItem.primaryISBN10,
            amazonURL: bookItem.amazonURL,
            reviewLink: bookItem.bookReviewLink
        )
    }
}
