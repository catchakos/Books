//
//  APIFake.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

class APIClient: APIClientInterface {
    enum LogLevel {
        case none
        case debug
    }

    private let logLevel: LogLevel = .debug
    internal let service: APIService

    lazy var session: URLSession = {
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 15
        return session
    }()
    
    required init(service: APIService, completion: @escaping (() -> Void)) {
        self.service = service
        completion()
    }

    func fetch(_ endpoint: Endpoint, completion: ((Data?, Error?, HTTPResponseCode?) -> Void)?) -> URLSessionDataTask? {
        guard let urlRequest = endpoint.urlRequest(for: service) else {
            completion?(nil, APIClientError.cannotMakeUrl, nil)
            return nil
        }

        if logLevel == .debug {
            print("[APICLIENT] will Request: \(urlRequest)")
        }

        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if self.logLevel == .debug {
                if let httpResponse = response as? HTTPURLResponse {
                    print("[APICLIENT] got Response: \(httpResponse.statusCode)")
                }
                print("[APICLIENT] got Error = \(String(describing: error))")
            }

            completion?(data, error, (response as? HTTPURLResponse)?.statusCode)
        }
        dataTask.resume()

        return dataTask
    }
    func fetch<T>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, APIClientError>) -> Void) -> URLSessionDataTask? where T : Decodable {
        return fetch(endpoint) { data, error, _ in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.emptyResponse))
                }
                return
            }

            do {
                let result = try responseType.init(jsonData: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.parsing))
                }
            }
        }
    }
}
