//
//  APIVersion.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import Foundation

protocol APIService {
    var scheme: String { get }
    var baseHost: String { get }
    var authenticationItem: [String: String]? { get }
    var rootPath: String? { get }
}
