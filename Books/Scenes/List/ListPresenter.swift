//
//  ListPresenter.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ListPresentationLogic {
    func presentLoad(_ response: List.Load.Response)
    func presentClear(_ response: List.Clear.Response)
    func presentItemSelect(_ response: List.Select.Response)
}

class ListPresenter: ListPresentationLogic {
    weak var viewController: ListDisplayLogic?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    // MARK: Load

    func presentLoad(_ response: List.Load.Response) {
        let dateString = dateFormatter.string(from: response.date)

        let vm = List.Load.ViewModel(
            dateText: String(format: NSLocalizedString("Best sellers %@", comment: ""), [dateString]),
            books: response.books ?? [],
            errorMessage: response.error?.localizedDescription
        )
        viewController?.displayLoad(vm)
    }

    // MARK: Clear

    func presentClear(_: List.Clear.Response) {
        let vm = List.Clear.ViewModel()
        viewController?.displayClear(vm)
    }

    // MARK: Select

    func presentItemSelect(_ response: List.Select.Response) {
        let vm = List.Select.ViewModel(success: response.book != nil)
        viewController?.displaySelectListItem(vm)
    }
}
