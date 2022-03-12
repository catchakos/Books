//
//  DetailPresenter.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DetailPresentationLogic {
    func presentLoad(_ response: Detail.Load.Response)
}

class DetailPresenter: DetailPresentationLogic {
    weak var viewController: DetailDisplayLogic?
    
    private lazy var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    // MARK: Do Load
    
    func presentLoad(_ response: Detail.Load.Response) {
        let book = response.book
        var priceString = ""
        if let price = book?.price,
            let formattedPrice = priceFormatter.string(from: price as NSNumber) {
            priceString = formattedPrice
        }
        
        let viewModel = Detail.Load.ViewModel(
            title: book?.title.capitalized,
            author: book?.author,
            imageUrl: book?.image,
            price: priceString,
            errorMessage: response.error?.localizedDescription)
        viewController?.displayLoad(viewModel)
    }
}
