//
//  APIClient.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

class APIClient: APIClientInterface {
    lazy var session: URLSessionInterface = {
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 15
        return session
    }()

    required init(completion: @escaping (() -> Void)) {
        completion()
    }

    func fetch<T>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, APIClientError>) -> Void) -> URLSessionDataTask? where T: Decodable {
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
    
    private func fetch(_ endpoint: Endpoint, completion: ((Data?, Error?, HTTPResponseCode?) -> Void)?) -> URLSessionDataTask? {
        guard let urlRequest = endpoint.urlRequest(for: endpoint.service) else {
            completion?(nil, APIClientError.cannotMakeUrl, nil)
            return nil
        }

        Logger.log("Request: \(urlRequest)")
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                Logger.log("Response: \(httpResponse.statusCode)")
            }
            Logger.log("Error = \(String(describing: error))")

            completion?(data, error, (response as? HTTPURLResponse)?.statusCode)
        }
        dataTask.resume()

        return dataTask
    }
}

extension URLSession: URLSessionInterface {}
