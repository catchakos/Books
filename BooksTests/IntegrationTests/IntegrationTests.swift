//
//  IntegrationTests.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 30/10/22.
//

@testable import Books
import XCTest

final class IntegrationTests: XCTestCase {

    var listVCSpy: ListViewControllerSpy!
    var detailVCSpy: DetailViewControllerSpy!
    var window: UIWindow!
    var fakeDependencies: DependenciesMock!
    
    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupViewControllers()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    func setupViewControllers() {
        listVCSpy = ListViewControllerSpy()
        detailVCSpy = DetailViewControllerSpy()
        detailVCSpy.router?.dataStore?.listItem = ListItemFakes.fakeBothLinks
        
        fakeDependencies = DependenciesMock()
        fakeDependencies.make { }
        listVCSpy.router?.dataStore?.dependencies = fakeDependencies
        detailVCSpy.router?.dataStore?.dependencies = fakeDependencies
    }

    func loadListView() {
        window.addSubview(listVCSpy.view)
        RunLoop.current.run(until: Date())
    }
    
    func loadDetailView() {
        window.addSubview(detailVCSpy.view)
        RunLoop.current.run(until: Date())
    }

    
    // MARK: Test Doubles

    class DependenciesMock: DependenciesInterface {
        var persistency: PersistencyInterface? = PersistencyFake(completion: {})
        var router: Routing?
        var apiClient: APIClientInterface?
        
        func make(completion: @escaping (() -> Void)) {
            apiClient = APIClientMock(completion: {
                completion()
            })
        }
    }
    
    class APIClientMock: APIClient {
        
        required init(completion: @escaping (() -> Void)) {
            super.init(completion: completion)
                
            self.session = URLSessionMock()
        }
    }
    
    class URLSessionMock: URLSessionInterface {
        
        var displayListError = false
        var displayPreviewNoView = false

        lazy var listData = try! getData(fromJSON: "list")
        lazy var listErrorData = try! getData(fromJSON: "list_error")

        lazy var previewBorrowData = try! getData(fromJSON: "preview_borrow")
        lazy var previewNoViewData = try! getData(fromJSON: "preview_noview")
        
        func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            if let endpoint = request.url?.pathComponents.last {
                if endpoint == "hardcover-fiction.json" {
                    if displayListError {
                        completionHandler(listErrorData, nil, nil)
                    } else {
                        completionHandler(listData, nil, nil)
                    }
                }  else if endpoint == "books" {
                    if displayPreviewNoView {
                        completionHandler(previewNoViewData, nil, nil)
                    } else {
                        completionHandler(previewBorrowData, nil, nil)
                    }
                }
            }
            
            return URLSession.shared.dataTask(with: request)
        }
        
        enum TestError: Error {
            case fileNotFound
        }
        
        func getData(fromJSON fileName: String) throws -> Data {
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
                XCTFail("Missing File: \(fileName).json")
                throw TestError.fileNotFound
            }
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                throw error
            }
        }
    }
    
    class ListViewControllerSpy: ListViewController {
        
        var onDisplayLoadCalled: (() -> Void)?
        
        override func displayLoad(_ viewModel: List.Load.ViewModel) {
            super.displayLoad(viewModel)
            
            onDisplayLoadCalled?()
        }
        
    }
    
    class DetailViewControllerSpy: DetailViewController {
        
        var onPreviewDisplayCalled: (() -> Void)?
        
        override func displayPreview(_ viewModel: Detail.Preview.ViewModel) {
            super.displayPreview(viewModel)
            onPreviewDisplayCalled?()
        }
    }
    
    // MARK: Tests
    
   func testRemoteReturnsListShowsList() {
        let expect = XCTestExpectation(description: "List shown")
        listVCSpy.onDisplayLoadCalled = {
            XCTAssert(self.listVCSpy.tableView.numberOfRows(inSection: 0) == 20)
            expect.fulfill()
        }
        
        loadListView()
        
        wait(for: [expect], timeout: 2)
    }
    
    func testRemoteReturnsListErrorShowsError() {
        ((fakeDependencies.apiClient as! APIClientMock).session as! URLSessionMock).displayListError = true
        
        let expect = XCTestExpectation(description: "Error shown")
        listVCSpy.onDisplayLoadCalled = {
            XCTAssertFalse(self.listVCSpy.errorLabel.isHidden)
            XCTAssertFalse((self.listVCSpy.errorLabel.text ?? "").isEmpty)
            expect.fulfill()
        }
        
        loadListView()
                
        wait(for: [expect], timeout: 2)
    }
    
    func testRemoteReturnsPreviewEnablesPreview() {
        let expect = XCTestExpectation(description: "Preview")
        detailVCSpy.onPreviewDisplayCalled = {
            XCTAssert(self.detailVCSpy.previewButton.isEnabled)
            XCTAssertFalse(self.detailVCSpy.previewButton.isHidden)
            expect.fulfill()
        }
        loadDetailView()
        
        wait(for: [expect], timeout: 2)
    }
    
    func testRemoteReturnsPreviewErrorShowsError() {
        ((fakeDependencies.apiClient as! APIClientMock).session as! URLSessionMock).displayPreviewNoView = true
        
        let expect = XCTestExpectation(description: "Preview Error")
        detailVCSpy.onPreviewDisplayCalled = {
            XCTAssertTrue(self.detailVCSpy.previewButton.isHidden)
            expect.fulfill()
        }
        loadDetailView()
        
        wait(for: [expect], timeout: 2)
    }

}
