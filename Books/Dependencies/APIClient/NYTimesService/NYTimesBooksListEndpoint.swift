//
//  NYTimesBooksListEndpoint.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import Foundation

struct NYTimesBooksListEndpoint: Endpoint {
    
    let service: APIService = NYTimesBookListService.v3
    
    var method: HTTPMethod<Body, Parameters> {
        return .get([:])
    }

    var path: String {
        return "/lists/2016-10-10/hardcover-fiction.json"
    }
}
