//
//  BooksWorkerTests.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

@testable import Books
import XCTest

class BooksWorkerTests: XCTestCase {
    // MARK: Subject under test

    var sut: BooksWorker!
    var remoteStoreSpy: BooksStoreSpy!
    var persistencySpy: PersistencySpy!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupBooksWorker()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupBooksWorker() {
        remoteStoreSpy = BooksStoreSpy()
        persistencySpy = PersistencySpy(completion: {})
        sut = BooksWorker(store: remoteStoreSpy, persistency: persistencySpy)
    }

    // MARK: Test doubles

    class BooksStoreSpy: BooksRemoteStoreProtocol {
        var fetchListCalled = false
        var fetchListOffsetPassed: Int?
        var fetchDetailCalled = false
        var fetchDetailIDPassed: String?
        var postBookCalled = false

        var fakeListReturnSuccess = true
        var fakeDetailReturnSuccess = true
        var fakePostReturnSuccess = true

        func fetchBooksList(offset: Int, count _: Int, completion: @escaping ((Result<ListItems, Error>) -> Void)) {
            fetchListCalled = true
            fetchListOffsetPassed = offset

            completion(fakeListReturnSuccess ? .success(BookFakes.fakeList1) : .failure(APIClientError.other))
        }

        func fetchBookDetail(id: String, completion: @escaping ((Result<ItemDetails, Error>) -> Void)) {
            fetchDetailCalled = true
            fetchDetailIDPassed = id

            completion(fakeDetailReturnSuccess ? .success(BookFakes.fakeBook1) : .failure(APIClientError.other))
        }

        func postRandomBook(completion: @escaping ((Result<Book, Error>) -> Void)) {
            postBookCalled = true

            completion(fakePostReturnSuccess ? .success(BookFakes.fakeBook1) : .failure(APIClientError.other))
        }
    }

    class PersistencySpy: PersistencyInterface {
        var isListening: Bool?
        var persistBookCalled = false
        var persistBookPassed: Book?
        var isPersistedBookCalled = false

        var fakePersistBookResult = false
        var fakeIsPersisted = false

        required init(completion: @escaping (() -> Void)) {
            completion()
        }

        func startListeningToBooks(updateHandler _: @escaping (() -> Void)) {
            isListening = true
        }

        func stopListeningToBooks() {
            isListening = false
        }

        func persist(book: Book) -> Bool {
            persistBookCalled = true
            persistBookPassed = book

            return fakePersistBookResult
        }

        func persistedBook(id _: String) -> Book? {
            isPersistedBookCalled = true
            return fakeIsPersisted ? BookFakes.fakeBook1 : nil
        }
    }

    // MARK: Tests

    func testFetchListCallsRemoteStore() {
        sut.fetchBooksList(offset: 0, count: 10) { _ in }

        XCTAssert(remoteStoreSpy.fetchListCalled)
    }

    func testFetchListSuccess() {
        let expect = XCTestExpectation(description: "fetchListSuccessCompletion")
        remoteStoreSpy.fakeListReturnSuccess = true

        sut.fetchBooksList(offset: 0, count: 10) { result in
            if case Result.success = result {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testFetchListFailure() {
        let expect = XCTestExpectation(description: "fetchListFailureCompletion")
        remoteStoreSpy.fakeListReturnSuccess = false

        sut.fetchBooksList(offset: 0, count: 10) { result in
            if case Result.failure = result {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testFetchDetailCallsRemoteStore() {
        sut.fetchBookDetail(id: "1", completion: { _ in })

        XCTAssert(remoteStoreSpy.fetchDetailCalled)
    }

    func testFetchDetailSuccess() {
        let expect = XCTestExpectation(description: "fetchDetailSuccessCompletion")
        remoteStoreSpy.fakeDetailReturnSuccess = true
        persistencySpy.fakePersistBookResult = true

        sut.fetchBookDetail(id: "1") { result in
            if case Result.success = result {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testFetchDetailFailure() {
        let expect = XCTestExpectation(description: "fetchDetailFailureCompletion")
        remoteStoreSpy.fakeDetailReturnSuccess = false

        sut.fetchBookDetail(id: "1") { result in
            if case Result.failure = result {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testFetchDetailSuccessPersistsItem() {
        let expect = XCTestExpectation(description: "fetchDetailSuccessPersists")
        remoteStoreSpy.fakeDetailReturnSuccess = true

        sut.fetchBookDetail(id: "1") { _ in
            if self.persistencySpy.persistBookCalled {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testFetchDetailFailurePersistsNoItem() {
        let expect = XCTestExpectation(description: "fetchDetailSuccessPersists")
        remoteStoreSpy.fakeDetailReturnSuccess = false

        sut.fetchBookDetail(id: "1") { _ in
            if !self.persistencySpy.persistBookCalled {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testAddBookCallsRemoteStore() {
        sut.addRandomBook(completion: { _ in })

        XCTAssert(remoteStoreSpy.postBookCalled)
    }

    func testAddBookSuccess() {
        let expect = XCTestExpectation(description: "addBookSuccess")
        remoteStoreSpy.fakePostReturnSuccess = true
        persistencySpy.fakePersistBookResult = true

        sut.addRandomBook { result in
            if case Result.success = result {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testAddBookFailure() {
        let expect = XCTestExpectation(description: "addBookFailure")
        remoteStoreSpy.fakePostReturnSuccess = false

        sut.addRandomBook { result in
            if case Result.failure = result {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testAddBookSuccessPersistsItem() {
        let expect = XCTestExpectation(description: "addBookSuccessPersists")
        remoteStoreSpy.fakePostReturnSuccess = true

        sut.addRandomBook { _ in
            if self.persistencySpy.persistBookCalled {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testAddBookFailurePersistsNoItem() {
        let expect = XCTestExpectation(description: "addBookFailurePersistsNoItem")
        remoteStoreSpy.fakePostReturnSuccess = false

        sut.addRandomBook { _ in
            if !self.persistencySpy.persistBookCalled {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }
}
