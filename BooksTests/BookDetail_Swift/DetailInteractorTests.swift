//
//  DetailInteractorTests.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import Books
import XCTest

class DetailInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: DetailInteractor!
    var spyPresenter: DetailPresentationLogicSpy!
    var spyWorker: BooksWorkerSpy!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupDetailInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupDetailInteractor() {
        spyPresenter = DetailPresentationLogicSpy()
        spyWorker = BooksWorkerSpy()
        
        sut = DetailInteractor(dependencies: DependenciesFake(), presenter: spyPresenter)
        sut.listItem = BookFakes.fakeListItem1
        sut.worker = spyWorker
    }

    // MARK: Test doubles

    class DetailPresentationLogicSpy: DetailPresentationLogic {
        var presentLoadCalled = false

        var onLoadCalled: (() -> Void)?

        func presentLoad(_: Detail.Load.Response) {
            presentLoadCalled = true
            onLoadCalled?()
        }
    }

    class BooksWorkerSpy: BooksWorkerProtocol {
        var fetchDetailCalled = false

        var fakeDetailSuccess = false

        func fetchBooksList(offset _: Int, count _: Int, completion: @escaping ((Result<ListItems, BooksError>) -> Void)) {
            completion(.success(BookFakes.fakeList1))
        }

        func fetchBookDetail(id _: String, completion: @escaping ((Result<Book, BooksError>) -> Void)) {
            fetchDetailCalled = true

            completion(fakeDetailSuccess ? .success(BookFakes.fakeBook1) : .failure(.other))
        }

        func addRandomBook(completion: @escaping ((Result<Book, BooksError>) -> Void)) {
            completion(.success(BookFakes.fakeBook1))
        }
    }

    // MARK: Tests

    func testDoLoad() {
        let expect = XCTestExpectation(description: "loadCallsPresenter")
        spyPresenter.onLoadCalled = {
            XCTAssertTrue(self.spyPresenter.presentLoadCalled, "doLoad(request:) should ask the presenter to format the result")
            expect.fulfill()
        }

        let request = Detail.Load.Request()
        sut.doLoad(request)

        wait(for: [expect], timeout: 1)
    }

    func testLoadCallsWorker() {
        let request = Detail.Load.Request()
        sut.doLoad(request)

        XCTAssertTrue(spyWorker.fetchDetailCalled, "doLoad(request:) should ask the presenter to format the result")
    }
}
