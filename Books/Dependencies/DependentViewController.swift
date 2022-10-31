//
//  DependentViewController.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import UIKit

protocol DependentViewController: UIViewController {
    var dataStore: DependentStore { get }

    init(dependencies: DependenciesInterface)
}

extension DependentViewController {
    init(nibName _: String?, bundle _: Bundle?) {
        fatalError("You have to initialize your VC through init(dependencies:)")
    }
}
