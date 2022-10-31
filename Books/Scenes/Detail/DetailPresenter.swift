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
    func presentPreview(_ response: Detail.Preview.Response)
}

class DetailPresenter: DetailPresentationLogic {
    weak var viewController: DetailDisplayLogic?

    // MARK: Do Load

    func presentLoad(_ response: Detail.Load.Response) {
        let book = response.book

        let viewModel = Detail.Load.ViewModel(
            title: book?.title.uppercased(),
            author: book?.author,
            imageUrl: book?.imageUrl,
            errorMessage: response.error?.localizedDescription,
            publisher: book?.publisher,
            isbn: book?.primaryISBN10,
            descriptionText: book?.bookDescription
        )
        viewController?.displayLoad(viewModel)
    }

    // MARK: Preview

    func presentPreview(_ response: Detail.Preview.Response) {
        let vm = Detail.Preview.ViewModel(hasPreview: response.hasPreview)
        viewController?.displayPreview(vm)
    }
}
