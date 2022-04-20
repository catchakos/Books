//
//  ListSnapshots.swift
//  BooksTests
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

@testable import Books
import SnapshotTesting
import XCTest

class ListSnapshots: XCTestCase {

    func testListControllerLoad() {
        let vc = ListViewController()
        vc.dataStore?.dependencies = DependenciesFake()

        let vm = List.Load.ViewModel(
            books: BookFakes.onePage,
            errorMessage: nil
        )
        vc.displayLoad(vm)

        let devices: [String: ViewImageConfig] = [
            "iPhoneX": .iPhoneX,
            "iPhone8": .iPhone8,
            "iPhoneSe": .iPhoneSe
        ]

        let results = devices.map { device in
            verifySnapshot(
                matching: vc,
                as: .image(on: device.value),
                named: "List-\(device.key)",
                testName: "ListViewController"
            )
        }

        results.forEach { XCTAssertNil($0) }
    }

    func testListControllerError() {
        let vc = ListViewController()
        vc.dataStore?.dependencies = DependenciesFake()

        let vm = List.Load.ViewModel(
            books: [],
            errorMessage: "error"
        )
        vc.displayLoad(vm)

        assertSnapshot(
            matching: vc,
            as: .image,
            named: "listControllerError"
        )
    }
}
