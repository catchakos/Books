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
    var workerSpy: BooksWorkerSpy!
    var presenterSpy: ListPresentationLogicSpy!

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
        let dependencies = DependenciesFake()
        presenterSpy = ListPresentationLogicSpy()
        
        sut = ListInteractor(dependencies: dependencies, presenter: presenterSpy)
        
        workerSpy = BooksWorkerSpy()
        sut.worker = workerSpy
    }

    // MARK: Test doubles

    class ListPresentationLogicSpy: ListPresentationLogic {
        var presentLoadCalled = false
        var presentClearCalled = false
        var presentItemSelectCalled = false
        var presentAddCalled = false

        var presentLoadResponsePassed: List.Load.Response?
        var presentClearResponsePassed: List.Clear.Response?
        var presentSelectResponsePassed: List.Select.Response?

        var onPresentLoad: (() -> Void)?
        var onPresentClear: (() -> Void)?
        var onPresentItemSelect: (() -> Void)?

        func presentLoad(_ response: List.Load.Response) {
            presentLoadCalled = true
            presentLoadResponsePassed = response
            onPresentLoad?()
        }

        func presentClear(_ response: List.Clear.Response) {
            presentClearCalled = true
            presentClearResponsePassed = response
            onPresentClear?()
        }

        func presentItemSelect(_ response: List.Select.Response) {
            presentItemSelectCalled = true
            presentSelectResponsePassed = response
            onPresentItemSelect?()
        }
    }

    class BooksWorkerSpy: BooksWorkerProtocol {
        var fetchListCalled = false
        var fetchPreviewCalled = false

        var fakeListSuccess = true
        var fakePreviewSuccess = true

        func fetchBooksList(date: Date, completion: @escaping ((Result<ListItems, BooksError>) -> Void)) {
            fetchListCalled = true

            completion(fakeListSuccess ? .success(BookFakes.fakeList1) : .failure(.other))
        }

        func fetchBookPreviewURL(isbn: String, completion: @escaping ((Result<String, BooksError>) -> Void)) {
            fetchPreviewCalled = true

            completion(fakePreviewSuccess ? .success("www.url.com") : .failure(.other))
        }
    }

    // MARK: Tests

    // MARK: - Load

    func testCallsWorkerForLoading() {
        let request = List.Load.Request(date: Date())
        sut.loadList(request)

        XCTAssert(workerSpy.fetchListCalled, "should call booksWorker to load")
    }

    func testDoesNotLoadIfAlreadyLoading() {
        sut.isLoading = true

        let request = List.Load.Request(date: Date())
        sut.loadList(request)

        XCTAssertFalse(workerSpy.fetchListCalled, "should not load a page if already loading")
    }
    
    func testPresentsLoad() {
        let expect = XCTestExpectation(description: "loadListPresents")
        presenterSpy.onPresentLoad = {
            XCTAssertTrue(self.presenterSpy.presentLoadCalled, "loadList(_:) should ask the presenter to format the result")
            expect.fulfill()
        }

        let request = List.Load.Request(date: Date())
        sut.loadList(request)

        wait(for: [expect], timeout: 1)
    }

    func testPresentsBooks() {
        let expect = XCTestExpectation(description: "loadListPresents")
        presenterSpy.onPresentLoad = {
            XCTAssertTrue(self.presenterSpy.presentLoadResponsePassed!.books!.count > 0, "loadList(_:) should ask the presenter to format books result")
            expect.fulfill()
        }

        let request = List.Load.Request(date: Date())
        sut.loadList(request)

        wait(for: [expect], timeout: 1)
    }

    func testStoresDate() {
        let request = List.Load.Request(date: Date())
        sut.loadList(request)
        
        XCTAssertNotNil(sut.dateRequested)
    }
    
    func testPresentsErrorMessage() {
        let expect = XCTestExpectation(description: "loadListPresents")
        workerSpy.fakeListSuccess = false
        presenterSpy.onPresentLoad = {
            XCTAssertTrue(self.presenterSpy.presentLoadResponsePassed!.error != nil, "loadList(_:) should ask the presenter to format books result")
            expect.fulfill()
        }

        let request = List.Load.Request(date: Date())
        sut.loadList(request)

        wait(for: [expect], timeout: 1)
    }

    // MARK: - Clear

    func testClearList() {
        let request = List.Clear.Request()

        sut.clearList(request)

        XCTAssertTrue(presenterSpy.presentClearCalled, "clearList(_:) should ask the presenter to format the result")
    }

    func testDoesNotKeepBooksInMemoryAfterClear() {
        sut.listItems = BookFakes.fakeList1

        let request = List.Clear.Request()
        sut.clearList(request)

        XCTAssertEqual(sut.listItems.count, 0, "should have cleared the list")
    }

    // MARK: - Select

    func testSelectItem() {
        sut.listItems = BookFakes.fakeList1
        let request = List.Select.Request(indexPath: IndexPath(row: 0, section: 0))
        sut.selectListItem(request)

        XCTAssertTrue(presenterSpy.presentItemSelectCalled, "selectListItem(_:) should ask the presenter to format the result")
    }

    func testSelectsBook() {
        sut.listItems = BookFakes.fakeList1
        let request = List.Select.Request(indexPath: IndexPath(row: 0, section: 0))
        sut.selectListItem(request)

        XCTAssertNotNil(presenterSpy.presentSelectResponsePassed?.book, "selectListItem(_:) should ask the presenter to format the item")
    }

    func testDoesNotSelectBookWhenPathOutOfRange() {
        sut.listItems = BookFakes.fakeList1
        let request = List.Select.Request(indexPath: IndexPath(row: 2, section: 0))
        sut.selectListItem(request)

        XCTAssertFalse(presenterSpy.presentItemSelectCalled, "selectListItem(_:) should not ask the presenter to format the item if out of range")
    }
}
