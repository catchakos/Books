//
//  APIFake.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

class FakeAPIClient: APIClientInterface {
    required init(completion: @escaping (() -> Void)) {
        completion()
    }

    func fetch(_: Endpoint, completion _: ((Data?, Error?, HTTPResponseCode?) -> Void)?) -> URLSessionDataTask? {
        return nil
    }

    func fetch<T>(endpoint _: Endpoint, responseType _: T.Type, completion _: @escaping (Result<T, APIClientError>) -> Void) -> URLSessionDataTask? where T: Decodable {
        return nil
    }
}
