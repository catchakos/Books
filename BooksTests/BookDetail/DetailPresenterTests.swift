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
    }

    // MARK: Test doubles

    class DetailDisplayLogicSpy: DetailDisplayLogic {
        var displayLoadCalled = false

        func displayLoad(_: Detail.Load.ViewModel) {
            displayLoadCalled = true
        }
    }

    // MARK: Tests

    func testPresentLoad() {
        // Given
        let spy = DetailDisplayLogicSpy()
        sut.viewController = spy
        let response = Detail.Load.Response(
            book: BookFakes.fakeBook1,
            error: nil
        )

        // When
        sut.presentLoad(response)

        // Then
        XCTAssertTrue(spy.displayLoadCalled, "presentLoad(response:) should ask the view controller to display the result")
    }
}
