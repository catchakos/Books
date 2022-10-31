//
//  PreviewInfo.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 29/10/22.
//

import Foundation

struct PreviewInfo: Codable {
    let previewURL: String
    let previewType: String

    enum CodingKeys: String, CodingKey {
        case previewURL = "preview_url"
        case previewType = "preview"
    }
}
