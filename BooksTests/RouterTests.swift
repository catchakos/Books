//
//  RouterTests.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 30/10/22.
//

@testable import Books
import XCTest

final class RouterTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: Router!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupRouter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupRouter() {
        sut = Router(window)
    }
    
    // MARK: Test doubles
    
    // MARK: Tests
    
    func testDisplaysSplashOnStart() {
        sut.start()
        
        XCTAssert(window.rootViewController is SplashViewController)
    }
}
