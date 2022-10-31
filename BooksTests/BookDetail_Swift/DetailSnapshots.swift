//
//  DetailSnapshots.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

@testable import Books
import SnapshotTesting
import XCTest

class DetailSnapshots: XCTestCase {
        
    func testDetailControllerLoad() {
        let vc = DetailViewController(dependencies: DependenciesFake())

        let vm = Detail.Load.ViewModel(
            title: "title",
            author: "author",
            imageUrl: nil,
            errorMessage: nil,
            publisher: "publisher",
            isbn: "111133334",
            descriptionText: "bla blah blah"
        )
        vc.displayLoad(vm)

        let devices: [String: ViewImageConfig] = [
            "iPhoneX": .iPhoneX,
            "iPhone8+": .iPhone8Plus
//            "iPhoneSe": .iPhoneSe
        ]

        let results = devices.map { device in
            verifySnapshot(
                matching: vc,
                as: .image(on: device.value),
                named: "Detail-\(device.key)",
                testName: "DetailViewController"
            )
        }

        results.forEach { XCTAssertNil($0) }
    }

    func testDetailControllerError() {
        let vc = DetailViewController(dependencies: DependenciesFake())

        let vm = Detail.Load.ViewModel(
            title: nil,
            author: nil,
            imageUrl: nil,
            errorMessage: "error",
            publisher: nil,
            isbn: nil,
            descriptionText: nil
        )
        vc.displayLoad(vm)

        assertSnapshot(
            matching: vc,
            as: .image,
            named: "DetailControllerError"
        )
    }
}
