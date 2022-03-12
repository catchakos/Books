//
//  UITableView+.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import UIKit

extension UITableView {
    
    // MARK: Register cells

    func register<R: UITableViewCell>(cell _: R.Type) {
        register(R.self, forCellReuseIdentifier: R.identifier)
    }

    func register<R: UITableViewHeaderFooterView>(header _: R.Type) {
        register(R.self, forHeaderFooterViewReuseIdentifier: R.identifier)
    }

    // MARK: Dequeue cells

    func dequeue<R: UITableViewCell>(cell: R.Type, indexPath: IndexPath) -> R {
        if let cell = dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as? R {
            return cell
        } else {
            fatalError("The cell should always be dequeable")
        }
    }

    func dequeue<R: UITableViewHeaderFooterView>(header _: R.Type) -> R {
        if let cell = dequeueReusableHeaderFooterView(withIdentifier: R.identifier) as? R {
            return cell
        } else {
            fatalError("The cell should always be dequeable")
        }
    }
}
