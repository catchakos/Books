//
//  NYTimesBooksListService.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import Foundation

enum NYTimesBookListService: APIService {
    
    case v3
    
    var scheme: String {
        return "https"
    }
    
    var baseHost: String {
        return "api.nytimes.com"
    }
    
    var authenticationItem: [String: String]? {
        return ["api-key": "9NPlJGhJKii67War2dCC9ul8CB06kJfN"]
    }
    
    var rootPath: String? {
        switch self {
        case .v3:
            return "/svc/books/v3"
        }
    }
}
