//
//  DetailRouterTests.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 30/10/22.
//

@testable import Books
import XCTest

final class DetailRouterTests: XCTestCase {

    var sut: DetailRouter!
    var backingVC: DetailViewControllerSpy!
    var window: UIWindow!
    var presenterDummy: PresenterSpy!

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
        backingVC = DetailViewControllerSpy(dependencies: DependenciesFake())
        sut = (backingVC.router as! DetailRouter)
        
        presenterDummy = PresenterSpy()
    }

    func loadView() {
        window.addSubview(presenterDummy.view)
        RunLoop.current.run(until: Date())
        
        presenterDummy.present(backingVC, animated: false)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles
    
    class PresenterSpy: UIViewController {
        var dismissCalled = false
        var onDismiss: (() -> Void)?
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissCalled = true
            onDismiss?()
        }
    }
    
    class DetailViewControllerSpy: DetailViewController {
        var presentCalled = false
        var vcToPresent: UIViewController?
        
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            presentCalled = true
            vcToPresent = viewControllerToPresent
        }
    }
    

    // MARK: Tests

    func testExitsDetail() {
        let expectation = XCTestExpectation(description: "dismissCalledOnPresenter")
        presenterDummy.onDismiss = {
            expectation.fulfill()
        }
        
        loadView()
        
        sut.exitDetail()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testRoutesToPreview() {
        sut.dataStore.previewURLString = "https://www.google.com"
        
        loadView()
        
        sut.routeToPreview()
        
        XCTAssert(backingVC.presentCalled)
    }
}
