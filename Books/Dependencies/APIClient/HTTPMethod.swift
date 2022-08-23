//
//  HTTPMethod.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import Foundation

typealias Parameters = [String: String]?
typealias Body = Any?

enum HTTPMethod<Body, Parameters> {
    case get(Parameters)
    case post(Body)
}

extension HTTPMethod {
    var value: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}
