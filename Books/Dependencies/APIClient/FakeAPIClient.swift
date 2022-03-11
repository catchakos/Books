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
    
    func fetch(_ endpoint: Endpoint, completion: ((Data?, Error?, HTTPResponseCode?) -> Void)?) -> URLSessionDataTask? {
        return nil
    }
    
    func fetch<T>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, APIClientError>) -> Void) -> URLSessionDataTask? where T : Decodable {
        return nil
    }
}
