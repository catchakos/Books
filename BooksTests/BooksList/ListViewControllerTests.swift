//
//  ListViewControllerTests.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import Books
import XCTest

class ListViewControllerTests: XCTestCase {
    // MARK: Subject under test

    var sut: ListViewController!
    var interactorSpy: ListBusinessLogicSpy!
    var routerSpy: ListRouterSpy!
    
    var window: UIWindow!

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
        sut = ListViewController()
        sut.router?.dataStore?.dependencies = DependenciesFake()
        
        interactorSpy = ListBusinessLogicSpy()
        sut.interactor = interactorSpy
        
        routerSpy = ListRouterSpy()
        sut.router = routerSpy
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles

    class ListBusinessLogicSpy: ListBusinessLogic {
        var loadListCalled = false
        var clearListCalled = false
        var selectListItemCalled = false

        func loadList(_: List.Load.Request) {
            loadListCalled = true
        }

        func clearList(_: List.Clear.Request) {
            clearListCalled = true
        }

        func selectListItem(_: List.Select.Request) {
            selectListItemCalled = true
        }
    }

    class ListRouterSpy: ListRouter {
        var routeToDetailCalled = false

        override func routeToDetail() {
            routeToDetailCalled = true
        }
    }

    // MARK: - Tests

    // MARK: - Load

    func testShouldLoadListWhenViewIsLoaded() {
        loadView()

        XCTAssertTrue(interactorSpy.loadListCalled, "viewDidLoad() should ask the interactor to load")
    }

    func testDisplayLoad() {
        loadView()
        
        let vm = List.Load.ViewModel(dateText: "the date", books: BookFakes.fakeList1, errorMessage: nil)
        sut.displayLoad(vm)

        XCTAssert(sut.tableView.numberOfSections == 1)
        XCTAssert(sut.tableView.numberOfRows(inSection: 0) == BookFakes.fakeList1.count)
    }

    func testDoesNotAppendResults() {
        loadView()

        let vm = List.Load.ViewModel(dateText: "the date", books: BookFakes.fakeList1, errorMessage: nil)
        sut.displayLoad(vm)
        
        let vm2 = List.Load.ViewModel(dateText: "the date", books: BookFakes.fakeList2, errorMessage: nil)
        sut.displayLoad(vm2)

        XCTAssert(sut.tableView.numberOfSections == 1)
        XCTAssert(sut.tableView.numberOfRows(inSection: 0) == BookFakes.fakeList2.count)
    }

    func testDisplaysFetchErrorMessage() {
        loadView()

        let vm = List.Load.ViewModel(dateText: "the date", books: [], errorMessage: "Error")
        sut.displayLoad(vm)

        XCTAssert(sut.errorLabel.text == vm.errorMessage)
        XCTAssertFalse(sut.errorLabel.isHidden)
    }

    func testHidesErrorMessageWithoutError() {
        loadView()

        let vm = List.Load.ViewModel(dateText: "the date", books: [], errorMessage: nil)
        sut.displayLoad(vm)

        XCTAssertTrue(sut.errorLabel.isHidden)
    }

    func testSpinsWhileFetching() {
        loadView()
        sut.loadList()

        XCTAssert(sut.spinner.isAnimating)
    }

    func testStopsSpinningWhenFinishedFetching() {
        loadView()
        sut.loadList()

        let vm = List.Load.ViewModel(dateText: "the date", books: [], errorMessage: nil)
        sut.displayLoad(vm)

        XCTAssertFalse(sut.spinner.isAnimating)
    }

    func DISABLEDtestLoadsNextPageWhenReachingBottom() {
        loadView()
        sut.displayLoad(List.Load.ViewModel(dateText: "the date", books: BookFakes.onePage, errorMessage: nil))
        interactorSpy.loadListCalled = false

        sut.tableHandler.onScrolledToBottom?()

        XCTAssertTrue(interactorSpy.loadListCalled)
    }
    
    func testLoadsCurrentDateByDefault() {
        loadView()
        
        XCTAssert(Date().timeIntervalSince1970 - sut.header.dateField.date.timeIntervalSince1970 < 1)
    }
    
    func testClearsListWhenDateChanges() {
        loadView()

        sut.header.dateField.sendActions(for: .valueChanged)
        
        XCTAssert(interactorSpy.clearListCalled)
    }
    
    func testLoadsWhenDateChanges() {
        loadView()
        
        sut.header.dateField.sendActions(for: .valueChanged)
        
        XCTAssert(interactorSpy.loadListCalled)
    }
    
    // MARK: - Clear

    func testShouldClearList() {
        loadView()
        sut.clearList()

        XCTAssertTrue(interactorSpy.clearListCalled, "viewDidLoad() should ask the interactor to clear")
    }

    func testDisplayClear() {
        loadView()
        let vm = List.Load.ViewModel(dateText: "the date", books: BookFakes.fakeList1, errorMessage: nil)
        sut.displayLoad(vm)
        
        let viewModel = List.Clear.ViewModel()
        sut.displayClear(viewModel)

        XCTAssert(sut.tableView.numberOfSections == 1)
        XCTAssert(sut.tableView.numberOfRows(inSection: 0) == 0)
    }

    // MARK: - Select

    func testShouldSelectItem() {
        loadView()
        sut.selectListItem(IndexPath(row: 0, section: 0))

        XCTAssertTrue(interactorSpy.selectListItemCalled, "viewDidLoad() should ask the interactor to select")
    }

    func testDisplaySelect() {
        loadView()

        let viewModel = List.Select.ViewModel(success: true)
        sut.displaySelectListItem(viewModel)

        XCTAssert(routerSpy.routeToDetailCalled)
    }

    func testDisplayNoSelectWithoutSuccess() {
        loadView()

        let viewModel = List.Select.ViewModel(success: false)
        sut.displaySelectListItem(viewModel)

        XCTAssertFalse(routerSpy.routeToDetailCalled)
    }
}
