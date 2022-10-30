//
//  DetailPresenterTests.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import Books
import XCTest

class DetailPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: DetailPresenter!
    var spyVC: DetailDisplayLogicSpy!
    
    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupDetailPresenter()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupDetailPresenter() {
        sut = DetailPresenter()
        
        spyVC = DetailDisplayLogicSpy()
        sut.viewController = spyVC
    }

    // MARK: Test doubles

    class DetailDisplayLogicSpy: DetailDisplayLogic {
        var displayPreviewCalled = false
        var displayLoadCalled = false

        func displayLoad(_: Detail.Load.ViewModel) {
            displayLoadCalled = true
        }
        
        func displayPreview(_ viewModel: Detail.Preview.ViewModel) {
            displayPreviewCalled = true
        }
    }

    // MARK: Tests

    func testPresentBookLoad() {
        let response = Detail.Load.Response(
            book: BookFakes.fakeBook1,
            error: nil
        )

        sut.presentLoad(response)

        XCTAssertTrue(spyVC.displayLoadCalled, "presentLoad(response:) should ask the view controller to display the result")
    }
    
    func testPresentLoadError() {
        let response = Detail.Load.Response(
            book: nil,
            error: .cannotFetch
        )

        sut.presentLoad(response)

        XCTAssertTrue(spyVC.displayLoadCalled, "presentLoad(response:) error should ask the view controller to display the result")
    }
    
    func testPresentPreview() {
        let response = Detail.Preview.Response(hasPreview: false)
        
        sut.presentPreview(response)
        
        XCTAssertTrue(spyVC.displayPreviewCalled, "presentPreview(response:) should ask the view controller to display the result")
    }
}
