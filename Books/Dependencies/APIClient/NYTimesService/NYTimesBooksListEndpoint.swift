//
//  NYTimesBooksListEndpoint.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import Foundation

struct NYTimesBooksListEndpoint: Endpoint {
    var method: HTTPMethod<Body, Parameters> {
        return .get([:])
    }
    
    var path: String? {
        return "/lists/current/e-book-fiction.json"
    }
}
