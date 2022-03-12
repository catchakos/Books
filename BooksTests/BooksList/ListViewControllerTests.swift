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
        sut.interactor = ListBusinessLogicSpy()
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
        var addListItemCalled = false
        
        func loadList(_ request: List.Load.Request) {
            loadListCalled = true
        }
        
        func clearList(_ request: List.Clear.Request) {
            clearListCalled = true
        }
        
        func selectListItem(_ request: List.Select.Request) {
            selectListItemCalled = true
        }
        
        func addItem(_ request: List.Add.Request) {
            addListItemCalled = true
        }
    }
    
    class ListRouterSpy: ListRouter {
        var routeToDetailCalled = false
        
        override func routeToDetail() {
            routeToDetailCalled = true
        }
    }
    
    // MARK: Tests
    
    // MARK: - Load
    
    func testShouldLoadListWhenViewIsLoaded() {
        let spy = ListBusinessLogicSpy()
        sut.interactor = spy
    
        loadView()
    
        XCTAssertTrue(spy.loadListCalled, "viewDidLoad() should ask the interactor to load")
    }
    
    func testDisplayLoad() {        
        let vm = List.Load.ViewModel(books: BookFakes.fakeList1, errorMessage: nil)
        
        sut.displayLoad(vm)
        
        XCTAssert(sut.tableView.numberOfSections == 1)
        XCTAssert(sut.tableView.numberOfRows(inSection: 0) == BookFakes.fakeList1.count)
    }
    
    func testAppendsResults() {
        let vm = List.Load.ViewModel(books: BookFakes.fakeList1, errorMessage: nil)
        
        sut.displayLoad(vm)
        sut.displayLoad(vm)
        
        XCTAssert(sut.tableView.numberOfSections == 1)
        XCTAssert(sut.tableView.numberOfRows(inSection: 0) == BookFakes.fakeList1.count * 2)
    }
    
    func testDisplaysFetchErrorMessage() {
        let vm = List.Load.ViewModel(books: [], errorMessage: "Error")
        
        sut.displayLoad(vm)
        
        XCTAssert(sut.errorLabel.text == vm.errorMessage)
        XCTAssertFalse(sut.errorLabel.isHidden)
    }
    
    func testHidesErrorMessageWithoutError() {
        let vm = List.Load.ViewModel(books: [], errorMessage: nil)
        
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
        
        let vm = List.Load.ViewModel(books: [], errorMessage: nil)
        sut.displayLoad(vm)
        
        XCTAssertFalse(sut.spinner.isAnimating)
    }
    
    func testLoadsNextPageWhenReachingBottom() {
        let spy = ListBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        sut.displayLoad(List.Load.ViewModel(books: BookFakes.onePage, errorMessage: nil))
        spy.loadListCalled = false
        
        sut.tableHandler.onScrolledToBottom?()
        
        XCTAssertTrue(spy.loadListCalled)
    }
    // MARK: - Clear
    
    func testShouldClearList() {
        let spy = ListBusinessLogicSpy()
        sut.interactor = spy
    
        loadView()
        sut.clearList()
    
        XCTAssertTrue(spy.clearListCalled, "viewDidLoad() should ask the interactor to clear")
    }
    
    func testDisplayClear() {
        let viewModel = List.Clear.ViewModel()
        
        loadView()
        sut.displayClear(viewModel)
        
        XCTAssert(sut.tableView.numberOfRows(inSection: 0) == 0)
    }
    
    // MARK: - Select
    
    func testShouldSelectItem() {
        let spy = ListBusinessLogicSpy()
        sut.interactor = spy
    
        loadView()
        //TODO: do it with UI
        sut.selectListItem(IndexPath(row: 0, section: 0))
    
        XCTAssertTrue(spy.selectListItemCalled, "viewDidLoad() should ask the interactor to select")
    }
    
    func testDisplaySelect() {
        let routerSpy = ListRouterSpy()
        sut.router = routerSpy
        loadView()
        
        let viewModel = List.Select.ViewModel(success: true)
        sut.displaySelectListItem(viewModel)
        
        XCTAssert(routerSpy.routeToDetailCalled)
    }
    
    func testDisplayNoSelectWithoutSuccess() {
        let routerSpy = ListRouterSpy()
        sut.router = routerSpy
        loadView()
        
        let viewModel = List.Select.ViewModel(success: false)
        sut.displaySelectListItem(viewModel)
        
        XCTAssertFalse(routerSpy.routeToDetailCalled)
    }
    
    // MARK: - Add
    
    func testShouldAddItem() {
        let spy = ListBusinessLogicSpy()
        sut.interactor = spy
    
        loadView()
        //TODO: do it with UI
        sut.addListItem()
    
        XCTAssertTrue(spy.addListItemCalled, "viewDidLoad() should ask the interactor to add")
    }
    
    func testDisplayNoErrorWithAddSuccess() {
        let viewModel = List.Add.ViewModel(success: true, errorMessage: nil)
        
        loadView()
        sut.displayAddListItem(viewModel)
        
        XCTAssert(sut.errorLabel.isHidden)
    }
    
    func testDisplayErrorWithAddFailure() {
        let viewModel = List.Add.ViewModel(success: false, errorMessage: "error")
        
        loadView()
        sut.displayAddListItem(viewModel)
        
        XCTAssertFalse(sut.errorLabel.isHidden)
    }
}
