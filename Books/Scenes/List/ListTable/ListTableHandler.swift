//
//  ListTableHandler.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import UIKit

class ListTableHandler: NSObject {
    private weak var tableView: UITableView?
    private var items = [ListItems]()

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
            
            let page = self.items[indexPath.section]
            let item = page[indexPath.row]
            cell.configure(item)
            
            return cell
        })

        tableView.dataSource = diffableDataSource
    }

    private func makeInitialTableSnapshot() {
        let snapshot = NSDiffableDataSourceSnapshot<ListPage, ListItem>()
        diffableDataSource?.apply(snapshot)
    }
    
    func add(newItems: [ListItem]) {
        guard newItems.count > 0 else {
            return
        }

        items.append(newItems)
        
        var snapshot = diffableDataSource?.snapshot() ?? NSDiffableDataSourceSnapshot<ListPage, ListItem>()
        let page = ListPage(number: snapshot.sectionIdentifiers.count)
        snapshot.appendSections([page])
        snapshot.appendItems(newItems, toSection: page)
        diffableDataSource?.apply(snapshot)
    }

    func clear() {
        items.removeAll()
        
        guard var snapshot = diffableDataSource?.snapshot() else {
            return
        }
        snapshot.deleteAllItems()
        diffableDataSource?.apply(snapshot)
    }
}

extension ListTableHandler: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == items.count - 1,
           indexPath.row == (items.last?.count ?? 1) - 1 {
            onScrolledToBottom?()
        }
    }
}
