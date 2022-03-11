//
//  SplashRouter.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol SplashRoutingLogic {
    //func routeToSomewhere()
}

protocol SplashDataPassing {
    var dataStore: SplashDataStore? { get }
}

class SplashRouter: NSObject, SplashRoutingLogic, SplashDataPassing {
    weak var viewController: SplashViewController?
    var dataStore: SplashDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere() {
    //    let destinationVC = SomewhereViewController()
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: SplashViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: SplashDataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}
