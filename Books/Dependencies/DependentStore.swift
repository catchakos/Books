//
//  DependentStore.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

protocol DependentStore: AnyObject {
    var dependencies: DependenciesInterface { get set }
}
