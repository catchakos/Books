//
//  ListInteractorTests.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import Books
import XCTest

class ListInteractorTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: ListInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupListInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupListInteractor() {
        sut = ListInteractor()
    }
    
    // MARK: Test doubles
    
    class ListPresentationLogicSpy: ListPresentationLogic {
        var presentLoadCalled = false
        var presentClearCalled = false
        var presentItemSelectCalled = false
        
        func presentLoad(_ request: List.Load.Response) {
            presentLoadCalled = true
        }
        
        func presentClear(_ request: List.Clear.Response) {
            presentClearCalled = true
        }
        
        func presentItemSelect(_ request: List.Select.Response) {
            presentItemSelectCalled = true
        }
    }
    
    // MARK: Tests
    
    // MARK: - Load
    
    func testLoadList() {
        let spy = ListPresentationLogicSpy()
        sut.presenter = spy
        let request = List.Load.Request()
        
        sut.loadList(request)
        
        XCTAssertTrue(spy.presentLoadCalled, "loadList(_:) should ask the presenter to format the result")
    }
    
    func testLoadsNextOffset() {
        XCTFail()
    }
    
    func testDoesNotLoadIfAlreadyLoading() {
        XCTFail()
    }
    
    func testPresentsErrorMessage() {
        XCTFail()
    }
    
    func testPresentsBooks() {
        XCTFail()
    }
    
    func testCallsWorkerForLoading() {
        
    }
    
    // MARK: - Clear
    
    func testClearList() {
        let spy = ListPresentationLogicSpy()
        sut.presenter = spy
        let request = List.Clear.Request()
        
        sut.clearList(request)
        
        XCTAssertTrue(spy.presentClearCalled, "clearList(_:) should ask the presenter to format the result")
    }
    
    func testDoesNotKeepBooksInMemoryAfterClear() {
        XCTFail()
    }
    
    // MARK: - Select
    
    func testSelectItem() {
        let spy = ListPresentationLogicSpy()
        sut.presenter = spy
        let request = List.Select.Request(indexPath: IndexPath(item: 0, section: 0))
        
        sut.selectListItem(request)
        
        XCTAssertTrue(spy.presentItemSelectCalled, "selectListItem(_:) should ask the presenter to format the result")
    }
    
    func testSelectsBook() {
        XCTFail()
    }
    
    func testDoesNotSelectBookWhenPathOutOfRange() {
        XCTFail()
    }
    
    // MARK: - Add
    
    func testAddItem() {
        XCTFail()
    }
    
    func testAddItemFailure() {
        XCTFail()
    }
    
    func testCallsWorkerForAdding() {
        
    }
}
