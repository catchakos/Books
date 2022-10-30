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
    var depencenciesSpy: DependenciesSpy!
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
        
        depencenciesSpy = DependenciesSpy()
        sut.dependencies = depencenciesSpy
    }
    
    // MARK: Test doubles
    
    class DependenciesSpy: Dependencies {
        var makeCalled = false
        
        override func make(completion: @escaping (() -> Void)) {
            makeCalled = true
            completion()
        }
    }
    
    // MARK: Tests
    
    func testDisplaysSplashOnStart() {
        sut.start()
        
        XCTAssert(window.rootViewController is SplashViewController)
    }
    
    func testStartsMakingDependenciesOnStart() {
        sut.start()
        
        XCTAssert(depencenciesSpy.makeCalled)
    }
}
