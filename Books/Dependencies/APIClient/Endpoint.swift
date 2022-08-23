//
//  Endpoint.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

protocol Endpoint {
    var method: HTTPMethod<Body, Parameters> { get }
    var timeout: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var headers: [String: String]? { get }
    var host: String? { get }
    var queryItems: [String: String]? { get }
    var path: String? { get }
}

extension Endpoint {
    var timeout: TimeInterval {
        return 60
    }

    var cachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }

    var headers: [String: String]? {
        return nil
    }

    var host: String? {
        return nil
    }
    
    var queryItems: [String: String]? {
        return nil
    }
}

extension Endpoint {
    func urlRequest(for service: APIService) -> URLRequest? {
        guard let url = url(for: service) else {
            return nil
        }

        var urlRequest = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeout
        )
        urlRequest.httpMethod = method.value

        var httpHeaders = ["Content-Type": "application/json"]
        if let endpointHeaders = headers {
            endpointHeaders.forEach {
                httpHeaders[$0.key] = $0.value
            }
        }
        httpHeaders.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }

        switch method {
        case .get:
            break
        case let .post(body):
            if let string = body as? String {
                urlRequest.httpBody = string.data(using: .utf8)
            } else if let bodyData = try? JSONSerialization.data(withJSONObject: body as Any, options: []) {
                urlRequest.httpBody = bodyData
            }
        }

        return urlRequest
    }

    func url(for service: APIService) -> URL? {
        assert(path != nil)

        if let endpointPath = path {
            var urlComponents = URLComponents()
            urlComponents.scheme = service.scheme
            urlComponents.host = host ?? service.baseHost
            
            assert(endpointPath.first == "/", "paths should start with /")
            urlComponents.path = endpointPath
            
            switch method {
            case let .get(parameters):
                if let parameters = parameters,
                   parameters.count > 0 {
                    urlComponents.queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
                }
            case .post:
                if let items = queryItems {
                    urlComponents.queryItems = items.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
                }
            }
            
            return urlComponents.url
        } else {
            assertionFailure("an endpoint should provide a relative path")
            return nil
        }
    }
}
