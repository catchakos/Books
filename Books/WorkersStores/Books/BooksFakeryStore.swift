//
//  BooksFakeryStore.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import Fakery
import Foundation

class BooksFakeryStore: BooksRemoteStoreProtocol {
    let faker = Faker()

    func fetchBooksList(date _: Date, completion: @escaping ((Result<ListItems, Error>) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            var items = [ListItem]()
            for _ in 0 ..< 20 {
                items.append(self.generateListItem())
            }

            completion(.success(items))
        }
    }

    func fetchBookPreviewInfo(isbn _: String, completion: @escaping ((Result<PreviewInfo, Error>) -> Void)) {
        completion(.failure(NSError(domain: "fakery", code: 400)))
    }

    // MARK: Generation

    private func generateListItem() -> ListItem {
        return ListItem(
            id: UUID().uuidString,
            link: faker.internet.url(),
            title: bookTitle(),
            author: "",
            bookDescription: faker.lorem.paragraph(),
            imageUrl: nil,
            publisher: faker.name.lastName(),
            primaryISBN10: faker.bank.bban(),
            amazonURL: faker.internet.url(),
            reviewLink: faker.internet.url()
        )
    }

    private func bookTitle() -> String {
        var words = [String]()
        for _ in 0 ..< ((Int(arc4random()) % 6) + 1) {
            words.append(bookTitleWord())
        }

        return words.joined(separator: " ")
    }

    private func bookTitleWord() -> String {
        switch arc4random() % 8 {
        case 0:
            return faker.address.city()
        case 1:
            return faker.address.streetName()
        case 2:
            return faker.address.secondaryAddress()
        case 3:
            return faker.address.country()
        case 4:
            return faker.name.firstName()
        case 5:
            return faker.house.furniture()
        case 6:
            return faker.team.creature()
        case 7:
            return faker.commerce.color()
        default:
            return ""
        }
    }
}
