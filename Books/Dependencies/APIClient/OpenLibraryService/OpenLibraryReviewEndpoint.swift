//
//  OpenLibraryReviewEndpoint.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 29/10/22.
//

import Foundation

struct OpenLibraryReviewEndpoint: Endpoint {

    let service: APIService = OpenLibraryService.v1

    private var isbn: String
    
    init(isbn: String) {
        self.isbn = isbn
    }
    
    var method: HTTPMethod<Body, Parameters> {
        return .get([
            "bibkeys": "ISBN:\(isbn)",
            "format": "json"
        ])
    }
    
    var path: String {
        return "/books"
    }
}
