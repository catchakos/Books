//
//  NYTimesBooksListEndpoint.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import Foundation

struct NYTimesBooksListEndpoint: Endpoint {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()

    let service: APIService = NYTimesBookListService.v3
    let date: Date

    var method: HTTPMethod<Body, Parameters> {
        return .get([:])
    }

    var path: String {
        let dateString: String
        if Calendar.current.isDateInToday(date) {
            dateString = "current"
        } else {
            dateString = Self.dateFormatter.string(from: date)
        }
        return "/lists/\(dateString)/hardcover-fiction.json"
    }
}
