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
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles

    class DetailBusinessLogicSpy: DetailBusinessLogic {
        var doLoadCalled = false

        func doLoad(_: Detail.Load.Request) {
            doLoadCalled = true
        }
    }

    // MARK: Tests

    func testShouldDoLoadWhenViewIsLoaded() {
        let spy = DetailBusinessLogicSpy()
        sut.interactor = spy

        loadView()

        XCTAssertTrue(spy.doLoadCalled, "viewDidLoad() should ask the interactor to do Load")
    }

    func testDisplayLoadTitle() {
        let viewModel = Detail.Load.ViewModel(
            title: "title",
            author: "author",
            imageUrl: nil,
            price: "price",
            errorMessage: nil
        )

        loadView()
        sut.displayLoad(viewModel)

        XCTAssertEqual(sut.titleLabel.text, viewModel.title)
    }

    func testDisplayLoadPrice() {
        let viewModel = Detail.Load.ViewModel(
            title: "title",
            author: "author",
            imageUrl: nil,
            price: "price",
            errorMessage: nil
        )

        loadView()
        sut.displayLoad(viewModel)

        XCTAssertEqual(sut.priceLabel.text, viewModel.price)
    }

    func testDisplayLoadAuthor() {
        let viewModel = Detail.Load.ViewModel(
            title: "title",
            author: "author",
            imageUrl: nil,
            price: "price",
            errorMessage: nil
        )

        loadView()
        sut.displayLoad(viewModel)

        XCTAssertEqual(sut.authorLabel.text, viewModel.author)
    }
}
