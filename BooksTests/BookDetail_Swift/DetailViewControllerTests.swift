//
//  DetailViewControllerTests.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import Books
import XCTest

class DetailViewControllerTests: XCTestCase {
    // MARK: Subject under test

    var sut: DetailViewController!
    var routerSpy: DetailRouterSpy!
    var interactorSpy: DetailBusinessLogicSpy!
    var window: UIWindow!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupDetailViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupDetailViewController() {
        sut = DetailViewController()
        routerSpy = DetailRouterSpy()
        sut.router = routerSpy
        interactorSpy = DetailBusinessLogicSpy()
        sut.interactor = interactorSpy
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles

    class DetailBusinessLogicSpy: DetailBusinessLogic {
        var doLoadCalled = false
        var loadPreviewCalled = false
        
        func doLoad(_: Detail.Load.Request) {
            doLoadCalled = true
        }
        
        func loadPreview(_ request: Detail.Preview.Request) {
            loadPreviewCalled = true
        }
    }
    
    class DetailRouterSpy: NSObject, DetailRoutingLogic, DetailDataPassing {
        var dataStore: DetailDataStore?
        
        var exitDetailCalled = false
        var onExitCalled: (() -> Void)?
        var routeToPreviewCalled = false
        var onRouteToPreviewCalled: (() -> Void)?
        
        func exitDetail() {
            exitDetailCalled = true
            onExitCalled?()
        }
        
        func routeToPreview() {
            routeToPreviewCalled = true
            onRouteToPreviewCalled?()
        }
    }
    
    let fakeLoadVM = Detail.Load.ViewModel(
        title: "title",
        author: "author",
        imageUrl: nil,
        errorMessage: nil,
        publisher: "publi",
        isbn: "1112223331",
        descriptionText: "blah blah blah"
    )

    // MARK: Tests

    func testShouldDoLoadWhenViewIsLoaded() {
        loadView()

        XCTAssertTrue(interactorSpy.doLoadCalled, "viewDidLoad() should ask the interactor to do Load")
    }

    func testLoadDisplaysTitle() {
        loadView()
        sut.displayLoad(fakeLoadVM)

        XCTAssertEqual(sut.titleLabel.text, fakeLoadVM.title)
    }
    
    func testLoadDisplaysAuthor() {
        loadView()
        sut.displayLoad(fakeLoadVM)

        XCTAssertEqual(sut.authorLabel.text, fakeLoadVM.author)
    }
    
    func testLoadDisplaysPublisher() {
        loadView()
        sut.displayLoad(fakeLoadVM)

        XCTAssertEqual(sut.publisherLabel.text, fakeLoadVM.publisher)
    }
    
    func testLoadDisplaysISBN() {
        loadView()
        sut.displayLoad(fakeLoadVM)

        XCTAssertEqual(sut.isbnLabel.text, fakeLoadVM.isbn)
    }
    
    func testLoadDisplaysDescription() {
        loadView()
        sut.displayLoad(fakeLoadVM)

        XCTAssertEqual(sut.descriptionLabel.text, fakeLoadVM.descriptionText)
    }
    
    func testDismissesWithTapOnDimmedView() {
        let expect = XCTestExpectation(description: "exit called")
        loadView()
        
        routerSpy.onExitCalled = {
            expect.fulfill()
        }
        
        let tapGestureRecognizer = sut.dimmedView.gestureRecognizers?.first as? UITapGestureRecognizer
        XCTAssertNotNil(tapGestureRecognizer, "Missing tap gesture")
                
        tapGestureRecognizer?.state = .ended
        
        wait(for: [expect], timeout: 1)
    }
    
    func testLoadsPreviewWhenViewIsLoaded() {
        loadView()

        XCTAssertTrue(interactorSpy.loadPreviewCalled, "viewDidLoad() should ask the interactor to fetch the preview")
    }
    
    func testDisplaysPreviewButtonWithPreview() {
        loadView()
        
        let vm = Detail.Preview.ViewModel(hasPreview: true)
        sut.displayPreview(vm)
        
        XCTAssertFalse(sut.previewButton.isHidden)
    }
    
    func testHidesPreviewButtonWithoutPreview() {
        loadView()
        
        let vm = Detail.Preview.ViewModel(hasPreview: false)
        sut.displayPreview(vm)
        
        XCTAssert(sut.previewButton.isHidden)
    }
    
    func testDisplaysMessageWithoutPreview() {
        loadView()
        
        let vm = Detail.Preview.ViewModel(hasPreview: false)
        sut.displayPreview(vm)
        
        XCTAssertFalse((sut.previewLabel.text ?? "").isEmpty)
        XCTAssertFalse(sut.previewLabel.isHidden)
    }
    
    func testRoutesToPreview() {
        loadView()
        
        sut.previewButton.sendActions(for: .touchUpInside)
        
        XCTAssert(routerSpy.routeToPreviewCalled)
    }
}
