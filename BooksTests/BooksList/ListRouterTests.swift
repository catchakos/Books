//
//  ListRouterTests.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 30/10/22.
//

@testable import Books
import XCTest

final class ListRouterTests: XCTestCase {

    var sut: ListRouter!
    var backingVC: ListViewControllerSpy!
    var window: UIWindow!
    var dummyNavController: DummyNavigationController!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupListViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupListViewController() {
        backingVC = ListViewControllerSpy()
        sut = (backingVC.router as! ListRouter)

        dummyNavController = DummyNavigationController(rootViewController: backingVC)
    }

    func loadView() {
        window.addSubview(dummyNavController.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles
    
    class ListViewControllerSpy: ListViewController {
        var presentCalled = false
        var vcToPresent: UIViewController?
        
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            presentCalled = true
            vcToPresent = viewControllerToPresent
        }
    }
    
    class DummyNavigationController: UINavigationController {
        var pushCalled = false
        var vcToPush: UIViewController!
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushCalled = true
            vcToPush = viewController
        }
    }
    

    // MARK: Tests

    func testRoutesToDetail() {
        sut.routeToDetail()
        
        XCTAssert(dummyNavController.pushCalled || backingVC.presentCalled)
    }
}
