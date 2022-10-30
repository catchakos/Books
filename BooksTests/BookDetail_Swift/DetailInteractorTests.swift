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
        
        var forcedPreviewReturn: Result<String, BooksError>?
        
        func fetchBooksList(date: Date, completion: @escaping ((Result<ListItems, BooksError>) -> Void)) {
            fetchListCalled = true
        }
        
        func fetchBookPreviewURL(isbn: String, completion: @escaping ((Result<String, BooksError>) -> Void)) {
            fetchPreviewCalled = true
            
            if let forcedPreviewReturn {
                completion(forcedPreviewReturn)
            }
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
    
    func testPreviewSuccessPresents() {
        spyWorker.forcedPreviewReturn = .success("www.google.com")
        
        let request = Detail.Preview.Request()
        sut.loadPreview(request)
        
        XCTAssert(spyPresenter.presentPreviewCalled)
    }
    
    func testPreviewFailurePresents() {
        spyWorker.forcedPreviewReturn = .failure(.cannotFetch)
        
        let request = Detail.Preview.Request()
        sut.loadPreview(request)
        
        XCTAssert(spyPresenter.presentPreviewCalled)
    }
    
    func testPreviewSuccessInDataStore() {
        let urlString = "www.google.com"
        spyWorker.forcedPreviewReturn = .success(urlString)
        
        let request = Detail.Preview.Request()
        sut.loadPreview(request)
        
        XCTAssertEqual(sut.previewURLString, urlString)
    }
    
    func testPreviewFailureInDataStore() {
        spyWorker.forcedPreviewReturn = .failure(.cannotFetch)
        
        let request = Detail.Preview.Request()
        sut.loadPreview(request)
        
        XCTAssertNil(sut.previewURLString)
    }
}
