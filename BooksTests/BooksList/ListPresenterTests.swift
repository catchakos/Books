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
        
        func displayLoad(_ viewModel: List.Load.ViewModel) {
            displayLoadCalled = true
        }
        
        func displayClear(_ viewModel: List.Clear.ViewModel) {
            displayClearCalled = true
        }
        
        func displaySelectListItem(_ viewModel: List.Select.ViewModel) {
            displaySelectItemCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentLoad() {
        let spy = ListDisplayLogicSpy()
        sut.viewController = spy
        let response = List.Load.Response(books: Books.none)
        
        sut.presentLoad(response)
        
        XCTAssertTrue(spy.displayLoadCalled, "presentLoad(_response:) should ask the view controller to display")
    }
    
    func testPresentsNewSectionWithLoadSuccess() {
        XCTFail()
    }
    
    func testPresentsNoErrorMessageWithLoadSuccess() {
        XCTFail()
    }
    
    func testPresentsNoSectionWithLoadFailure() {
        XCTFail()
    }
    
    func testPresentsErrorMessageWithLoadFailure() {
        XCTFail()
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
        XCTFail()
    }
    
    func testPresentsSelectingNoBook() {
        XCTFail()
    }
    
    func testPresentsAddingBook() {
        XCTFail()
    }
    
    func testPresentsAddingNoBook() {
        XCTFail()
    }
}
