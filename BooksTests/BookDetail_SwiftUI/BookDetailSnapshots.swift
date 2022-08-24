//
//  BookDetailSnapshots.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 24/8/22.
//

@testable import Books
import SnapshotTesting
import XCTest
import SwiftUI

class BookDetailSnapshots: XCTestCase {
        
    let devices: [String: ViewImageConfig] = [
        "iPhoneX": .iPhoneX,
        "iPhone8+": .iPhone8Plus
    ]
    
    func testBookDetailViewLoad() {
        snapAndTestBookDetailView(
            with: BookDetailVM(bookDetails: ListItem.mocked()),
            shotName: "BookDetailView")
    }
    
    func testBookDetailView_BookWithAmazonLink() {
        snapAndTestBookDetailView(
            with: BookDetailVMFakes.fakeAmazonButton,
            shotName: "BookDetailView_BookWithAmazonLink")
    }

    func testBookDetailView_BookWithReviewLink() {
        snapAndTestBookDetailView(
            with: BookDetailVMFakes.fakeReviewButton,
            shotName: "BookDetailView_BookWithReviewLink")
    }
    
    func testBookDetailView_BookWithAmazonAndReviewLink() {
        snapAndTestBookDetailView(
            with: BookDetailVMFakes.fakeAmazonAndReviewButtons,
            shotName: "BookDetailView_BookWithAmazonAndReviewLink")
    }

    private func snapAndTestBookDetailView(with vm: BookDetailVM, shotName: String) {        
        let view = BookDetailView(
            viewModel: vm,
            navigationController: nil)
        let hostVC = UIHostingController(rootView: view)

        devices.map { device in
            verifySnapshot(
                matching: hostVC,
                as: .image(on: device.value),
                named: "\(shotName)-\(device.key)",
                testName: "BookDetailView_SwiftUI"
            )
        }
        .forEach { XCTAssertNil($0) }
    }
}
