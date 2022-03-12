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
        sut = DetailInteractor()
        sut.listItem = BookFakes.fakeListItem1
    }
    
    // MARK: Test doubles
    
    class DetailPresentationLogicSpy: DetailPresentationLogic {
        var presentLoadCalled = false
        
        var onLoadCalled: (()->Void)?
        
        func presentLoad(_ response: Detail.Load.Response)
        {
            presentLoadCalled = true
            onLoadCalled?()
        }
    }
    
    class BooksWorkerSpy: BooksWorkerProtocol {
        var fetchDetailCalled = false
        
        var fakeDetailSuccess = false
        
        func fetchBooksList(offset: Int, count: Int, completion: @escaping ((Result<ListItems, BooksError>) -> Void)) {
            completion(.success(BookFakes.fakeList1))
        }
        
        func fetchBookDetail(id: String, completion: @escaping ((Result<Book, BooksError>) -> Void)) {
            fetchDetailCalled = true
            
            completion(fakeDetailSuccess ? .success(BookFakes.fakeBook1): .failure(.other))
        }
        
        func addRandomBook(completion: @escaping ((Result<Book, BooksError>) -> Void)) {
            completion(.success(BookFakes.fakeBook1))
        }
    }
    
    // MARK: Tests
    
    func testDoLoad() {
        let expect = XCTestExpectation(description: "loadCallsPresenter")
        let spy = DetailPresentationLogicSpy()
        spy.onLoadCalled = {
            XCTAssertTrue(spy.presentLoadCalled, "doLoad(request:) should ask the presenter to format the result")
            expect.fulfill()
        }
        sut.presenter = spy
        sut.worker = BooksWorkerSpy()
        
        let request = Detail.Load.Request()
        sut.doLoad(request)
        
        wait(for: [expect], timeout: 1)
    }
    
    func testLoadCallsWorker() {
        let spy = DetailPresentationLogicSpy()
        sut.presenter = spy
        let worker = BooksWorkerSpy()
        sut.worker = worker
       
        let request = Detail.Load.Request()
        sut.doLoad(request)
        
        XCTAssertTrue(worker.fetchDetailCalled, "doLoad(request:) should ask the presenter to format the result")
    }
}
