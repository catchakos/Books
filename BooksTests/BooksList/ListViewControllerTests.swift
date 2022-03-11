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
    
    // MARK: Tests
    
    // MARK: - Load
    
    func testShouldLoadListWhenViewIsLoaded() {
        let spy = ListBusinessLogicSpy()
        sut.interactor = spy
    
        loadView()
    
        XCTAssertTrue(spy.loadListCalled, "viewDidLoad() should ask the interactor to load")
    }
    
    func testDisplayLoad() {
        let viewModel = List.Load.ViewModel(books: Books.none)
        
        loadView()
        sut.displayLoad(viewModel)
        
        XCTFail()
    }
    
    func testLoadsNextPageWhenReachingBottom() {
        XCTFail()

    }
    
    func testAddsItemsToExisting() {
        XCTFail()

    }
    
    func testDisplaysFetchErrorMessage() {
        XCTFail()

    }
    
    func testKeepsExistingItemsWhenDisplayingFetchErrorMessage() {
        XCTFail()

    }
    
    func testSpinsWhileFetching() {
        XCTFail()

    }
    
    func testStopsSpinningWhenFinishedFetching() {
        XCTFail()

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
        
        XCTFail()
    }
    
    // MARK: - Select
    
    func testShouldSelectItem() {
        let spy = ListBusinessLogicSpy()
        sut.interactor = spy
    
        loadView()
        //TODO: do it with UI
        sut.selectListItem(IndexPath(item: 0, section: 0))
    
        XCTAssertTrue(spy.selectListItemCalled, "viewDidLoad() should ask the interactor to select")
    }
    
    func testDisplaySelect() {
        let viewModel = List.Select.ViewModel(success: true)
        
        loadView()
        sut.displaySelectListItem(viewModel)
        
        XCTFail()
    }
    
    func testDisplayNoSelectWithoutSuccess() {
        let viewModel = List.Select.ViewModel(success: false)
        
        loadView()
        sut.displaySelectListItem(viewModel)
        
        XCTFail()
    }
    
    func testDisplayNoneSelectedAtLaunch() {
        XCTFail()
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
    
    func testDisplayItemWithAddSuccess() {
        let viewModel = List.Add.ViewModel(success: true)
        
        loadView()
        sut.displayAddListItem(viewModel)
        
        XCTFail()
    }
    
    func testDisplayNoItemWithAddFailure() {
        XCTFail()
    }
}
