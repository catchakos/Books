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
        let vc = DetailViewController()
        vc.dataStore?.dependencies = DependenciesFake()

        let vm = Detail.Load.ViewModel(
            title: "title",
            author: "author",
            imageUrl: nil,
            price: "1€",
            errorMessage: nil
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
        let vc = DetailViewController()
        vc.dataStore?.dependencies = DependenciesFake()

        let vm = Detail.Load.ViewModel(
            title: nil,
            author: nil,
            imageUrl: nil,
            price: nil,
            errorMessage: "error"
        )
        vc.displayLoad(vm)

        assertSnapshot(
            matching: vc,
            as: .image,
            named: "DetailControllerError"
        )
    }
}
