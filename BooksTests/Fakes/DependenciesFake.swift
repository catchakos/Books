//
//  DependenciesFake.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

@testable import Books
import Foundation

class DependenciesFake: DependenciesInterface {
    func make(completion: @escaping (() -> Void)) {
        completion()
    }

    var persistency: PersistencyInterface? = PersistencyFake(completion: {})
    var router: Routing?
    var apiClient: APIClientInterface? = APIClientFake(service: NYTimesBookListService.v3)
}

class PersistencyFake: PersistencyInterface {
    func startListeningToBooks(updateHandler _: @escaping (() -> Void)) {}

    func stopListeningToBooks() {}

    func persist(book _: Book) -> Bool {
        return true
    }

    func persistedBook(id _: String) -> Book? {
        return nil
    }

    required init(completion _: @escaping (() -> Void)) {}
}

class APIClientFake: APIClientInterface {
    var service: APIService
    
    init(service: APIService) {
        self.service = service
    }
    
    func fetch(_ endpoint: Endpoint, completion: ((Data?, Error?, HTTPResponseCode?) -> Void)?) -> URLSessionDataTask? {
        DispatchQueue.main.async {
            completion?(nil, nil, nil)
        }
        return nil
    }
    
    func fetch<T>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, APIClientError>) -> Void) -> URLSessionDataTask? where T : Decodable {
        DispatchQueue.main.async {
            completion(.failure(.decodeError))
        }
        return nil
    }
    
    
}
