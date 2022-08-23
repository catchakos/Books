//
//  NYTimesBooksList.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import Foundation

struct NYTimesBooksList: Decodable {
    let copyright: String
    let resultsCount: Int
    let results: NYTimesBooksListItemsContainer
    
    enum CodingKeys: String, CodingKey {
        case copyright, results
        case resultsCount = "num_results"
    }
}

struct NYTimesBooksListItemsContainer: Decodable {
    let publishedDate: String
    let displayName: String
    let books: [NYTimesBooksListItem]
    
    enum CodingKeys: String, CodingKey {
        case publishedDate = "published_date"
        case displayName = "display_name"
        case books
    }
}

struct NYTimesBooksListItem: Decodable {
    let title: String
    let bookDescription: String
    let contributor: String
    let author: String
    let publisher: String
    let primaryISBN10: String
    let bookImage: String
    let rank: Int
    let rankLastWeek: Int
    let amazonURL: String
    let bookReviewLink: String
    
    enum CodingKeys: String, CodingKey {
        case rank, title, contributor, author, publisher
        case bookDescription = "description"
        case rankLastWeek = "rank_last_week"
        case amazonURL = "amazon_product_url"
        case primaryISBN10 = "primary_isbn10"
        case bookImage = "book_image"
        case bookReviewLink = "book_review_link"
    }
}
