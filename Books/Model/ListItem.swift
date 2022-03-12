//
//  ListItem.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

typealias ListItems = [ListItem]

struct ListItem: Codable {
    let id: String
    let link: String
    let title: String
}

extension ListItems {
    static let none: ListItems = []
}
