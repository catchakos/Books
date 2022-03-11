//
//  DependentViewController.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import UIKit

protocol DependentViewController: UIViewController {
    var dataStore: DependentStore? { get }
}

extension DependentViewController {}
