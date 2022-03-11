//
//  Routing.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import UIKit

protocol Routing: AnyObject {
    init(_ window: UIWindow?)

    func start()
    func enterBackground()
    func enterForeground()

    func canHandle(_ url: URL) -> Bool
    func handle(_ url: URL)
    func handle(_ route: Route)
}
