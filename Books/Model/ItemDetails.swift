//
//  ItemDetails.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

struct ItemDetails: Codable {
    let id: String
    let image: String?
    let title: String
    let author: String
    let price: Double
}
