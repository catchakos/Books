//
//  APIClientInterface.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

typealias HTTPResponseCode = Int

protocol APIClientInterface: Dependency {
    var service: APIService { get }

    func fetch(_ endpoint: Endpoint, completion: ((Data?, Error?, HTTPResponseCode?) -> Void)?) -> URLSessionDataTask?

    func fetch<T: Decodable>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, APIClientError>) -> Void) -> URLSessionDataTask?
}
