//
//  ListPresenterTests.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import Books
import XCTest

class ListPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: ListPresenter!
    var vcSpy: ListDisplayLogicSpy!
    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupListPresenter()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupListPresenter() {
        sut = ListPresenter()
        
        vcSpy = ListDisplayLogicSpy()
        sut.viewController = vcSpy
    }

    // MARK: Test doubles

    class ListDisplayLogicSpy: ListDisplayLogic {
        var displayLoadCalled = false
        var displayClearCalled = false
        var displaySelectItemCalled = false

        var displayLoadVMPassed: List.Load.ViewModel?
        var displaySelectVMPassed: List.Select.ViewModel?

        func displayLoad(_ viewModel: List.Load.ViewModel) {
            displayLoadCalled = true
            displayLoadVMPassed = viewModel
        }

        func displayClear(_: List.Clear.ViewModel) {
            displayClearCalled = true
        }

        func displaySelectListItem(_ viewModel: List.Select.ViewModel) {
            displaySelectItemCalled = true
            displaySelectVMPassed = viewModel
        }
    }

    // MARK: Tests

    func testPresentLoad() {
        let response = List.Load.Response(date: Date(), books: ListItems.none, error: nil)

        sut.presentLoad(response)

        XCTAssertTrue(vcSpy.displayLoadCalled, "presentLoad(_response:) should ask the view controller to display")
    }

    func testPresentsNoErrorMessageWithLoadSuccess() {
        let response = List.Load.Response(date: Date(), books: ListItems.none, error: nil)

        sut.presentLoad(response)

        XCTAssertNil(vcSpy.displayLoadVMPassed?.errorMessage, "presentLoad(_response:) should not present error message")
    }

    func testPresentsBooksWithLoadSuccess() {
        let response = List.Load.Response(date: Date(), books: BookFakes.fakeList1, error: nil)

        sut.presentLoad(response)

        XCTAssertNotNil(vcSpy.displayLoadVMPassed?.books, "presentLoad(_response:) should present books")
    }

    func testPresentsNoItemsWithLoadFailure() {
        let response = List.Load.Response(date: Date(), books: nil, error: .other)

        sut.presentLoad(response)

        XCTAssert(vcSpy.displayLoadVMPassed?.books.count == 0, "presentLoad(_response:) should not present books")
    }

    func testPresentsErrorMessageWithLoadFailure() {
        let response = List.Load.Response(date: Date(), books: nil, error: .other)

        sut.presentLoad(response)

        XCTAssertNotNil(vcSpy.displayLoadVMPassed?.errorMessage, "presentLoad(_response:) should present error message")
    }

    func testPresentsFormattedDate() {
        let day = 1
        let month = 8
        let year = 2022
        let date = DateComponents(calendar: .current, year: year, month: month, day: day).date!
        let response = List.Load.Response(date: date, books: nil, error: .other)
        sut.presentLoad(response)

        let text = vcSpy.displayLoadVMPassed?.dateText ?? ""
        XCTAssert([day, year] // true for english or latin-related but..
            .map( { String($0) })
            .filter({ text.contains($0) })
            .count == 2
        )
    }
    
    func testPresentClear() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Clear.Response()

        sut.presentClear(response)

        XCTAssertTrue(spy.displayClearCalled, "presentClear(_response:) should ask the view controller to display")
    }

    func testPresentSelect() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Select.Response(book: nil)

        sut.presentItemSelect(response)

        XCTAssertTrue(spy.displaySelectItemCalled, "presentItemSelect(_:) should ask the view controller to display")
    }

    func testPresentsSelectingBook() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Select.Response(book: BookFakes.fakeListItem1)

        sut.presentItemSelect(response)

        XCTAssertTrue(spy.displaySelectVMPassed?.success ?? false, "presentItemSelect(_:) should ask the view controller to display success")
    }

    func testPresentsSelectingNoBook() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Select.Response(book: nil)

        sut.presentItemSelect(response)

        XCTAssertFalse(spy.displaySelectVMPassed?.success ?? true, "presentItemSelect(_:) should ask the view controller to display failure")
    }
}
