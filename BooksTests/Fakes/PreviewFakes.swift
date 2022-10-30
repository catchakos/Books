//
//  PreviewFakes.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 30/10/22.
//

import Foundation
@testable import Books

struct PreviewFakes {
    static let preview1 = PreviewInfo(
        previewURL: "http://www.google.com",
        previewType: "full")
    
    static let noPreview1 = PreviewInfo(
        previewURL: "http://www.google.com",
        previewType: "noview")
}
