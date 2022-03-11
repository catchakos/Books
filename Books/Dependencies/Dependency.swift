//
//  Dependency.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

protocol Dependency {
    init(completion: @escaping (() -> Void))
}
