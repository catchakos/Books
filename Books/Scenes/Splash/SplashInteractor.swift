//
//  SplashInteractor.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SplashBusinessLogic {
    func doSomething(_ request: Splash.Something.Request)
}

protocol SplashDataStore: DependentStore {
}

class SplashInteractor: SplashBusinessLogic, SplashDataStore {
    var dependencies: DependenciesInterface?
    var presenter: SplashPresentationLogic?
    
    // MARK: Do something
    
    func doSomething(_ request: Splash.Something.Request) {
        let response = Splash.Something.Response()
        presenter?.presentSomething(response)
    }
}
