//
//  ListTableHandler.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import UIKit

class ListTableHandler: NSObject {
    private weak var tableView: UITableView?
    private var items = [ListItem]()

    var onSelection: ((IndexPath) -> Void)?
    var onScrolledToBottom: (() -> Void)?

    init(table: UITableView) {
        tableView = table

        super.init()

        setupTable()
        table.reloadData()
    }

    private func setupTable() {
        tableView?.register(cell: ListCell.self)

        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 120

        if #available(iOS 15.0, *) {
            tableView?.sectionHeaderTopPadding = 0.0
            tableView?.tableHeaderView = UIView()
        }
    }

    func add(newItems: [ListItem]) {
        guard newItems.count > 0 else {
            return
        }
        
        items.append(contentsOf: newItems)
        tableView?.reloadData()
    }
    
    func clear() {
        items.removeAll()
        tableView?.reloadData()
    }
}

extension ListTableHandler: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: ListCell.self, indexPath: indexPath)
        cell.configure(items[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            onScrolledToBottom?()
        }
    }
}

extension ListTableHandler: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection?(indexPath)
    }
}


