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

    func fetchBooksList(offset _: Int, count: Int, completion: @escaping ((Result<ListItems, Error>) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            var items = [ListItem]()
            for _ in 0 ..< count {
                items.append(self.generateListItem())
            }

            completion(.success(items))
        }
    }

    func fetchBookDetail(id _: String, completion: @escaping ((Result<ItemDetails, Error>) -> Void)) {
        completion(.success(generateItemDetails()))
    }

    func postRandomBook(completion _: @escaping ((Result<Book, Error>) -> Void)) {}

    // MARK: Generation

    private func generateListItem() -> ListItem {
        return ListItem(
            id: UUID().uuidString,
            link: faker.internet.url(),
            title: bookTitle()
        )
    }

    private func generateItemDetails() -> ItemDetails {
        return ItemDetails(
            id: UUID().uuidString,
            image: faker.internet.image(),
            title: bookTitle(),
            author: faker.name.name(),
            price: faker.commerce.price()
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
