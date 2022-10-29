//
//  OpenLibraryService.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 29/10/22.
//

import Foundation

/**
  Open Library API Integration
 */
enum OpenLibraryService: APIService {
    
    case v1
    
    var scheme: String {
        return "https"
    }

    var baseHost: String {
        return "openlibrary.org"
    }
    
    var authenticationItem: [String: String]? {
        return nil
    }
    
    var rootPath: String? {
        switch self {
        case .v1:
            return "/api"
        }
    }
    
}
