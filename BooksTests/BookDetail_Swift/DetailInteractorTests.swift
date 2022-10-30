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
        setupDoubles()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupDetailInteractor() {
        sut = DetailInteractor()
        sut.listItem = BookFakes.fakeListItem1
    }
    
    func setupDoubles() {
        spyPresenter = DetailPresentationLogicSpy()
        sut.presenter = spyPresenter
        spyWorker = BooksWorkerSpy()
        sut.worker = spyWorker
    }
    
    // MARK: Test doubles
    
    class DetailPresentationLogicSpy: DetailPresentationLogic {
        var presentLoadCalled = false
        var presentPreviewCalled = false
        
        var onLoadCalled: (() -> Void)?
        
        func presentLoad(_: Detail.Load.Response) {
            presentLoadCalled = true
            onLoadCalled?()
        }
        
        func presentPreview(_ response: Detail.Preview.Response) {
            presentPreviewCalled = true
        }
    }
    
    class BooksWorkerSpy: BooksWorkerProtocol {
        var fetchListCalled = false
        var fetchPreviewCalled = false
        
        func fetchBooksList(date: Date, completion: @escaping ((Result<ListItems, BooksError>) -> Void)) {
            fetchListCalled = true
        }
        
        func fetchBookPreviewURL(isbn: String, completion: @escaping ((Result<String, BooksError>) -> Void)) {
            fetchPreviewCalled = true
        }
    }
    
    // MARK: Tests
    
    func testDoLoad() {
        let request = Detail.Load.Request()
        sut.doLoad(request)
        
        XCTAssert(spyPresenter.presentLoadCalled)
    }
    
    func testPreviewCallsWorker() {
        let request = Detail.Preview.Request()
        sut.loadPreview(request)
        
        XCTAssert(spyWorker.fetchPreviewCalled)
    }
    
    // TODO:
//    func testPreviewSuccessPresents() {
//        XCTFail()
//    }
//    
//    func testPreviewFailurePresents() {
//        XCTFail()
//    }
//    
//    func testPreviewSuccessInDataStore() {
//        XCTFail()
//    }
//    
//    func testPreviewFailureInDataStore() {
//        XCTFail()
//    }
}
