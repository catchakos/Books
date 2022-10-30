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
        sut.dependencies = DependenciesFake()
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
        let workerSpy = BooksWorkerSpy()
        sut.worker = workerSpy

        let request = List.Load.Request(date: Date())
        sut.loadList(request)

        XCTAssert(workerSpy.fetchListCalled, "should call booksWorker to load")
    }

    func testDoesNotLoadIfAlreadyLoading() {
        let workerSpy = BooksWorkerSpy()
        sut.worker = workerSpy
        sut.isLoading = true

        let request = List.Load.Request(date: Date())
        sut.loadList(request)

        XCTAssertFalse(workerSpy.fetchListCalled, "should not load a page if already loading")
    }
    
    func testPresentsLoad() {
        let expect = XCTestExpectation(description: "loadListPresents")
        let workerSpy = BooksWorkerSpy()
        sut.worker = workerSpy
        let spy = ListPresentationLogicSpy()
        spy.onPresentLoad = {
            XCTAssertTrue(spy.presentLoadCalled, "loadList(_:) should ask the presenter to format the result")
            expect.fulfill()
        }
        sut.presenter = spy

        let request = List.Load.Request(date: Date())
        sut.loadList(request)

        wait(for: [expect], timeout: 1)
    }

    func testPresentsBooks() {
        let expect = XCTestExpectation(description: "loadListPresents")
        let workerSpy = BooksWorkerSpy()
        sut.worker = workerSpy
        let spy = ListPresentationLogicSpy()
        spy.onPresentLoad = {
            XCTAssertTrue(spy.presentLoadResponsePassed!.books!.count > 0, "loadList(_:) should ask the presenter to format books result")
            expect.fulfill()
        }
        sut.presenter = spy

        let request = List.Load.Request(date: Date())
        sut.loadList(request)

        wait(for: [expect], timeout: 1)
    }

    func testPresentsErrorMessage() {
        let expect = XCTestExpectation(description: "loadListPresents")
        let workerSpy = BooksWorkerSpy()
        workerSpy.fakeListSuccess = false
        sut.worker = workerSpy
        let spy = ListPresentationLogicSpy()
        spy.onPresentLoad = {
            XCTAssertTrue(spy.presentLoadResponsePassed!.error != nil, "loadList(_:) should ask the presenter to format books result")
            expect.fulfill()
        }
        sut.presenter = spy

        let request = List.Load.Request(date: Date())
        sut.loadList(request)

        wait(for: [expect], timeout: 1)
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
        sut.listItems = BookFakes.fakeList1

        let request = List.Clear.Request()
        sut.clearList(request)

        XCTAssertEqual(sut.listItems.count, 0, "should have cleared the list")
    }

    // MARK: - Select

    func testSelectItem() {
        sut.listItems = BookFakes.fakeList1
        let spy = ListPresentationLogicSpy()
        sut.presenter = spy

        let request = List.Select.Request(indexPath: IndexPath(row: 0, section: 0))
        sut.selectListItem(request)

        XCTAssertTrue(spy.presentItemSelectCalled, "selectListItem(_:) should ask the presenter to format the result")
    }

    func testSelectsBook() {
        sut.listItems = BookFakes.fakeList1
        let spy = ListPresentationLogicSpy()
        sut.presenter = spy

        let request = List.Select.Request(indexPath: IndexPath(row: 0, section: 0))
        sut.selectListItem(request)

        XCTAssertNotNil(spy.presentSelectResponsePassed?.book, "selectListItem(_:) should ask the presenter to format the item")
    }

    func testDoesNotSelectBookWhenPathOutOfRange() {
        sut.listItems = BookFakes.fakeList1
        let spy = ListPresentationLogicSpy()
        sut.presenter = spy

        let request = List.Select.Request(indexPath: IndexPath(row: 2, section: 0))
        sut.selectListItem(request)

        XCTAssertFalse(spy.presentItemSelectCalled, "selectListItem(_:) should not ask the presenter to format the item if out of range")
    }
}
