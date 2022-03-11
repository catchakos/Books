//
//  SplashPresenter.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SplashPresentationLogic {
    func presentSomething(_ response: Splash.Something.Response)
}

class SplashPresenter: SplashPresentationLogic {
    weak var viewController: SplashDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(_ response: Splash.Something.Response) {
        let viewModel = Splash.Something.ViewModel()
        viewController?.displaySomething(viewModel)
    }
}
