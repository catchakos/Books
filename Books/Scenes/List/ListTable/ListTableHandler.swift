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
    
    private var diffableDataSource: UITableViewDiffableDataSource<ListPage, ListItem>?

    init(table: UITableView) {
        tableView = table
        
        super.init()

        setupTable()
        setupDiffableDataSource()
        makeInitialTableSnapshot()
    }

    private func setupTable() {
        tableView?.register(cell: ListCell.self)

        tableView?.delegate = self

        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 120

        if #available(iOS 15.0, *) {
            tableView?.sectionHeaderTopPadding = 0.0
            tableView?.tableHeaderView = UIView()
        }
    }
    
    private func setupDiffableDataSource() {
        guard let tableView = tableView else {
            return
        }

        diffableDataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard let self = self else {
                return UITableViewCell()
            }
            
            let cell = tableView.dequeue(cell: ListCell.self, indexPath: indexPath)
            
            let item = self.items[indexPath.row]
            cell.configure(item)
            
            return cell
        })

        tableView.dataSource = diffableDataSource
    }

    private func makeInitialTableSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ListPage, ListItem>()
        snapshot.appendSections([ListPage(number: 0)])
        diffableDataSource?.apply(snapshot)
    }
    
    func add(newItems: [ListItem]) {
        guard newItems.count > 0 else {
            return
        }

        items.append(contentsOf: newItems)
        
        var snapshot = diffableDataSource?.snapshot() ?? NSDiffableDataSourceSnapshot<ListPage, ListItem>()
        snapshot.appendItems(newItems)
        diffableDataSource?.apply(snapshot)
    }

    func clear() {
        items.removeAll()
        tableView?.reloadData()
    }
}

extension ListTableHandler: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            onScrolledToBottom?()
        }
    }
}
