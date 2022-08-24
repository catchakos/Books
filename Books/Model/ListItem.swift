//
//  ListItem.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import Foundation

typealias ListItems = [ListItem]

struct ListItem: Codable, Hashable {
    let id: String
    let link: String?
    let title: String
    let author: String
    let bookDescription: String
    let imageUrl: URL?
    let publisher: String
    let primaryISBN10: String
    let amazonURL: String
    let reviewLink: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
#if DEBUG
    static func mocked() -> ListItem {
        return ListItem(
            id: UUID().uuidString,
            link: nil,
            title: "Inés y la alegría",
            author: "Almudena Grandes",
            bookDescription: "Toulouse, verano de 1939. Carmen de Pedro, responsable en Francia de los diezmados comunistas españoles, se cruza con Jesús Monzón, un ex cargo del partido que, sin ella intuirlo, alberga un ambicioso plan. Meses más tarde, Monzón, convertido en su pareja, ha organizado el grupo más disciplinado de la Resistencia contra la ocupación alemana, prepara la plataforma de la Unión Nacional Española y cuenta con un ejército de hombres dispuestos a invadir España. Entre ellos está Galán, que ha combatido en la Agrupación de Guerrilleros Españoles y que cree, como muchos otros en el otoño de 1944, que tras el desembarco aliado y la retirada de los alemanes, es posible establecer un gobierno republicano en Viella. No muy lejos de allí, Inés vive recluida y vigilada en casa de su hermano, delegado provincial de Falange en Lérida. Ha sufrido todas las calamidades desde que, sola en Madrid, apoyó la causa republicana durante la guerra, pero ahora, cuando oye a escondidas el anuncio de la operación Reconquista de España en Radio Pirenaica, Inés se arma de valor, y de secreta alegría, para dejar atrás los peores años de su vida.",
            imageUrl: URL(string: "https://storage.googleapis.com/du-prd/books/images/9780385538923.jpg"),
            publisher: "The Publisher",
            primaryISBN10: "13451345353",
            amazonURL: "",
            reviewLink: ""
        )
    }
#endif
}

extension ListItems {
    static let none: ListItems = []
}

