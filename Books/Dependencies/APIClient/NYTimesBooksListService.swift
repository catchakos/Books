//
//  NYTimesBooksListService.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import Foundation

struct NYTimesBookListService: APIService {
    
    private var APIVersion: String {
        return "v3"
    }
    
    var scheme: String {
        return "https"
    }
    
    var baseHost: String {
        return "api.nytimes.com/svc/books/\(APIVersion)"
    }
    
    var apiKey: String? {
        return "9NPlJGhJKii67War2dCC9ul8CB06kJfN"
    }
}
