//
//  ListItem.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

typealias ListItems = [ListItem]

struct ListItem: Codable, Hashable {
    let id: String
    let link: String?
    let title: String
    let author: String
    let imageUrl: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ListItems {
    static let none: ListItems = []
}

