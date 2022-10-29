//
//  ListTableHandler.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import UIKit

class ListTableHandler: NSObject {
    private weak var tableView: UITableView?
    private var items = ListItems()

    var onSelection: ((IndexPath) -> Void)?
    var onScrolledToBottom: (() -> Void)?

    init(table: UITableView) {
        tableView = table

        super.init()

        setupTable()
    }

    private func setupTable() {
        tableView?.register(cell: ListCell.self)

        tableView?.delegate = self
        tableView?.dataSource = self

        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 120

        if #available(iOS 15.0, *) {
            tableView?.sectionHeaderTopPadding = 0.0
            tableView?.tableHeaderView = UIView()
        }
    }

    func configure(_ items: ListItems) {
        self.items = items
        tableView?.reloadData()
    }
    
    func clear() {
        items.removeAll()
        tableView?.reloadData()
    }
}

extension ListTableHandler: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: ListCell.self, indexPath: indexPath)
        
        let item = items[indexPath.row]
        cell.configure(item)

        return cell
    }
}

extension ListTableHandler: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection?(indexPath)
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (items.count ?? 1) - 1 {
            onScrolledToBottom?()
        }
    }
}
