//
//  APIClientInterface.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

typealias HTTPResponseCode = Int

protocol URLSessionInterface {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

protocol APIClientInterface: Dependency {
    func fetch<T: Decodable>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, APIClientError>) -> Void) -> URLSessionDataTask?
}
