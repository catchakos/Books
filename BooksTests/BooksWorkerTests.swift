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
    
    let fakeISBN = "1112223334"

    class BooksStoreSpy: BooksRemoteStoreProtocol {
        var fetchListCalled = false
        var fetchListDatePassed: Date?
        var fetchPreviewCalled = false
        var fetchISBNPassed: String?

        var fakeListReturnSuccess = true
        var fakePreviewReturnSuccess = true

        func fetchBooksList(date: Date, completion: @escaping ((Result<ListItems, Error>) -> Void)) {
            fetchListCalled = true
            fetchListDatePassed = date

            completion(fakeListReturnSuccess ? .success(BookFakes.fakeList1) : .failure(APIClientError.decodeError))
        }

        func fetchBookPreviewInfo(isbn: String, completion: @escaping ((Result<PreviewInfo, Error>) -> Void)) {
            fetchPreviewCalled = true
            fetchISBNPassed = isbn

            completion(fakePreviewReturnSuccess ? .success(PreviewFakes.preview1) : .failure(APIClientError.decodeError))
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
        sut.fetchBooksList(date: Date()) { _ in }

        XCTAssert(remoteStoreSpy.fetchListCalled)
    }

    func testFetchListSuccess() {
        let expect = XCTestExpectation(description: "fetchListSuccessCompletion")
        remoteStoreSpy.fakeListReturnSuccess = true

        sut.fetchBooksList(date: Date()) { result in
            if case Result.success = result {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testFetchListFailure() {
        let expect = XCTestExpectation(description: "fetchListFailureCompletion")
        remoteStoreSpy.fakeListReturnSuccess = false

        sut.fetchBooksList(date: Date()) { result in
            if case Result.failure = result {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testFetchPreviewCallsRemoteStore() {
        sut.fetchBookPreviewURL(isbn: fakeISBN, completion: {_ in })

        XCTAssert(remoteStoreSpy.fetchPreviewCalled)
    }

    func testFetchPreviewSuccess() {
        let expect = XCTestExpectation(description: "fetchDetailSuccessCompletion")
        remoteStoreSpy.fakePreviewReturnSuccess = true
        persistencySpy.fakePersistBookResult = true

        sut.fetchBookPreviewURL(isbn: fakeISBN) { result in
            if case Result.success = result {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    func testFetchPreviewFailure() {
        let expect = XCTestExpectation(description: "fetchDetailFailureCompletion")
        remoteStoreSpy.fakePreviewReturnSuccess = false

        sut.fetchBookPreviewURL(isbn: fakeISBN) { result in
            if case Result.failure = result {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
    }

    
    /*
    func testSuccessPersistsItem() {
     XCTFail()
    }

    func testFetchFailurePersistsNoItem() {
        XCTFail()
    }
     */
}
