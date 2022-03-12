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
    }
    
    // MARK: Test doubles
    
    class ListDisplayLogicSpy: ListDisplayLogic {
        var displayLoadCalled = false
        var displayClearCalled = false
        var displaySelectItemCalled = false
        var displayAddCalled = false
        
        var displayLoadVMPassed: List.Load.ViewModel?
        var displaySelectVMPassed: List.Select.ViewModel?
        var displayAddVMPassed: List.Add.ViewModel?
        
        func displayLoad(_ viewModel: List.Load.ViewModel) {
            displayLoadCalled = true
            displayLoadVMPassed = viewModel
        }
        
        func displayClear(_ viewModel: List.Clear.ViewModel) {
            displayClearCalled = true
        }
        
        func displaySelectListItem(_ viewModel: List.Select.ViewModel) {
            displaySelectItemCalled = true
            displaySelectVMPassed = viewModel
        }
        
        func displayAddListItem(_ viewModel: List.Add.ViewModel) {
            displayAddCalled = true
            displayAddVMPassed = viewModel
        }
    }
    
    // MARK: Tests
    
    func testPresentLoad() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Load.Response(books: ListItems.none, error: nil)
        
        sut.presentLoad(response)
        
        XCTAssertTrue(spy.displayLoadCalled, "presentLoad(_response:) should ask the view controller to display")
    }
    
    func testPresentsNoErrorMessageWithLoadSuccess() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Load.Response(books: ListItems.none, error: nil)
        
        sut.presentLoad(response)
        
        XCTAssertNil(spy.displayLoadVMPassed?.errorMessage, "presentLoad(_response:) should not present error message")
    }
    
    func testPresentsBooksWithLoadSuccess() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Load.Response(books: BookFakes.fakeList1, error: nil)
        
        sut.presentLoad(response)
        
        XCTAssertNotNil(spy.displayLoadVMPassed?.books, "presentLoad(_response:) should present books")
    }
    
    func testPresentsNoItemsWithLoadFailure() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Load.Response(books: nil, error: .other)
        
        sut.presentLoad(response)
        
        XCTAssert(spy.displayLoadVMPassed?.books.count == 0, "presentLoad(_response:) should not present books")
    }
    
    func testPresentsErrorMessageWithLoadFailure() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Load.Response(books: nil, error: .other)
        
        sut.presentLoad(response)
        
        XCTAssertNotNil(spy.displayLoadVMPassed?.errorMessage, "presentLoad(_response:) should present error message")
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
    
    func testPresentsAddingBook() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Add.Response(book: BookFakes.fakeBook1)
        
        sut.presentAddItem(response)
        
        XCTAssertTrue(spy.displayAddVMPassed?.success ?? false, "presentAddItem(_:) should ask the view controller to display success")
    }
    
    func testPresentsAddingNoBook() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Add.Response(book: nil)
        
        sut.presentAddItem(response)
        
        XCTAssertFalse(spy.displayAddVMPassed?.success ?? true, "presentAddItem(_:) should ask the view controller to display failure")
    }
}
