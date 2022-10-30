//
//  BooksUITests.swift
//  BooksUITests
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import XCTest

class BooksUITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testListToDetail() throws {
        let app = XCUIApplication()
        app.launch()

        let table = app.tables["list_table"]
        XCTAssert(table.exists)

        let spinner = app.otherElements["spinner"]
        XCTAssertFalse(spinner.exists)

        table.swipeUp()
        table.cells.firstMatch.tap()

        let title = app.staticTexts["movie_detail_title"]
        XCTAssert(title.exists)
        
        let author = app.staticTexts["movie_detail_author"]
        XCTAssert(author.exists)
        
        let summary = app.staticTexts["movie_detail_summary"]
        XCTAssert(summary.exists)

        let publisher = app.staticTexts["movie_detail_publisher"]
        XCTAssert(publisher.exists)
        
        let isbn = app.staticTexts["movie_detail_isbn"]
        XCTAssert(isbn.exists)
        
        let image = app.images["movie_detail_image"]
        XCTAssert(image.exists)
        
        XCTFail("Should exit dETAIL!")
    }
}
