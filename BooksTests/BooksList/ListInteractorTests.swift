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
    var spyWorker: BooksWorkerSpy!
    var spyPresenter: ListPresentationLogicSpy!

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
        spyWorker = BooksWorkerSpy()
        spyPresenter = ListPresentationLogicSpy()
        sut = ListInteractor(dependencies: DependenciesFake(), presenter: spyPresenter)
        sut.worker = spyWorker
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
        var presentAddResponsePassed: List.Add.Response?

        var onPresentLoad: (() -> Void)?
        var onPresentClear: (() -> Void)?
        var onPresentItemSelect: (() -> Void)?
        var onPresentAdd: (() -> Void)?

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

        func presentAddItem(_ response: List.Add.Response) {
            presentAddCalled = true
            presentAddResponsePassed = response
            onPresentAdd?()
        }
    }

    class BooksWorkerSpy: BooksWorkerProtocol {
        var fetchListCalled = false
        var fetchDetailCalled = false
        var addBookCalled = false

        var fakeListSuccess = true
        var fakeDetailSuccess = true
        var fakeAddBookSuccess = true

        func fetchBooksList(offset _: Int, count _: Int, completion: @escaping ((Result<ListItems, BooksError>) -> Void)) {
            fetchListCalled = true

            completion(fakeListSuccess ? .success(BookFakes.fakeList1) : .failure(.other))
        }

        func fetchBookDetail(id _: String, completion: @escaping ((Result<Book, BooksError>) -> Void)) {
            fetchDetailCalled = true

            completion(fakeDetailSuccess ? .success(BookFakes.fakeBook1) : .failure(.other))
        }

        func addRandomBook(completion: @escaping ((Result<Book, BooksError>) -> Void)) {
            addBookCalled = true

            completion(fakeAddBookSuccess ? .success(BookFakes.fakeBook1) : .failure(.other))
        }
    }

    // MARK: Tests

    // MARK: - Load

    func testCallsWorkerForLoading() {
        let request = List.Load.Request()
        sut.loadList(request)

        XCTAssert(spyWorker.fetchListCalled, "should call booksWorker to load")
    }

    func testDoesNotLoadIfAlreadyLoading() {
        sut.isLoading = true

        let request = List.Load.Request()
        sut.loadList(request)

        XCTAssertFalse(spyWorker.fetchListCalled, "should not load a page if already loading")
    }

    func testLoadsNextOffset() {
        sut.offset = 0

        let expect = XCTestExpectation(description: "loadNextOffset")

        var firstLoadDone = false
        spyPresenter.onPresentLoad = {
            if !firstLoadDone {
                firstLoadDone = true
                let request = List.Load.Request()
                self.sut.loadList(request)
            } else {
                XCTAssertEqual(self.sut.offset, 2 * ListInteractor.Constants.pageSize, "should have raised the offset")
                expect.fulfill()
            }
        }

        let request = List.Load.Request()
        sut.loadList(request)

        wait(for: [expect], timeout: 1)
    }

    func testAppendsItemsOfConsequentLoads() {
        let expect = XCTestExpectation(description: "appendsConsequentLoadsItems")
    
        var firstLoadDone = false
        var count = 0
        spyPresenter.onPresentLoad = {
            if !firstLoadDone {
                firstLoadDone = true
                count = self.sut.listItems.count

                let request = List.Load.Request()
                self.sut.loadList(request)
            } else {
                XCTAssertGreaterThan(self.sut.listItems.count, count, "should have appended the items")
                expect.fulfill()
            }
        }

        let request = List.Load.Request()
        sut.loadList(request)

        wait(for: [expect], timeout: 1)
    }

    func testDoesNotChangeOffsetIfAlreadyLoading() {
        sut.isLoading = true
        let offset = sut.offset

        let request = List.Load.Request()
        sut.loadList(request)

        XCTAssertEqual(offset, sut.offset, "should change offset if already loading")
    }

    func testPresentsLoad() {
        let expect = XCTestExpectation(description: "loadListPresents")
    
        spyPresenter.onPresentLoad = {
            XCTAssertTrue(self.spyPresenter.presentLoadCalled, "loadList(_:) should ask the presenter to format the result")
            expect.fulfill()
        }

        let request = List.Load.Request()
        sut.loadList(request)

        wait(for: [expect], timeout: 1)
    }

    func testPresentsBooks() {
        let expect = XCTestExpectation(description: "loadListPresents")
        
        spyPresenter.onPresentLoad = {
            XCTAssertTrue(self.spyPresenter.presentLoadResponsePassed!.books!.count > 0, "loadList(_:) should ask the presenter to format books result")
            expect.fulfill()
        }

        let request = List.Load.Request()
        sut.loadList(request)

        wait(for: [expect], timeout: 1)
    }

    func testPresentsErrorMessage() {
        let expect = XCTestExpectation(description: "loadListPresents")

        spyWorker.fakeListSuccess = false
        
        spyPresenter.onPresentLoad = {
            XCTAssertTrue(self.spyPresenter.presentLoadResponsePassed!.error != nil, "loadList(_:) should ask the presenter to format books result")
            expect.fulfill()
        }

        let request = List.Load.Request()
        sut.loadList(request)

        wait(for: [expect], timeout: 1)
    }

    // MARK: - Clear

    func testClearList() {
        let request = List.Clear.Request()

        sut.clearList(request)

        XCTAssertTrue(spyPresenter.presentClearCalled, "clearList(_:) should ask the presenter to format the result")
    }

    func testDoesNotKeepBooksInMemoryAfterClear() {
        sut.listItems = [BookFakes.fakeList1]

        let request = List.Clear.Request()
        sut.clearList(request)

        XCTAssertEqual(sut.listItems.count, 0, "should have cleared the list")
    }

    // MARK: - Select

    func testSelectItem() {
        sut.listItems = [BookFakes.fakeList1]

        let request = List.Select.Request(indexPath: IndexPath(row: 0, section: 0))
        sut.selectListItem(request)

        XCTAssertTrue(spyPresenter.presentItemSelectCalled, "selectListItem(_:) should ask the presenter to format the result")
    }

    func testSelectsBook() {
        sut.listItems = [BookFakes.fakeList1]

        let request = List.Select.Request(indexPath: IndexPath(row: 0, section: 0))
        sut.selectListItem(request)

        XCTAssertNotNil(spyPresenter.presentSelectResponsePassed?.book, "selectListItem(_:) should ask the presenter to format the item")
    }

    func testDoesNotSelectBookWhenPathOutOfRange() {
        sut.listItems = [BookFakes.fakeList1]

        let request = List.Select.Request(indexPath: IndexPath(row: 2, section: 0))
        sut.selectListItem(request)

        XCTAssertFalse(spyPresenter.presentItemSelectCalled, "selectListItem(_:) should not ask the presenter to format the item if out of range")
    }

    // MARK: - Add

    func testAddItem() {
        let expect = XCTestExpectation(description: "addItemCallsPresenter")

        spyPresenter.onPresentAdd = {
            XCTAssertNotNil(self.spyPresenter.presentAddResponsePassed?.book)
            expect.fulfill()
        }

        let request = List.Add.Request()
        sut.addItem(request)

        wait(for: [expect], timeout: 1)
    }

    func testAddItemFailure() {
        let expect = XCTestExpectation(description: "addItemFailureCallsPresenter")
        spyPresenter.onPresentAdd = {
            XCTAssertNil(self.spyPresenter.presentAddResponsePassed?.book)
            expect.fulfill()
        }
        
        spyWorker.fakeAddBookSuccess = false

        let request = List.Add.Request()
        sut.addItem(request)

        wait(for: [expect], timeout: 1)
    }

    func testCallsWorkerForAdding() {
        let request = List.Add.Request()
        sut.addItem(request)

        XCTAssert(spyWorker.addBookCalled, "should have called worker to add")
    }
}
