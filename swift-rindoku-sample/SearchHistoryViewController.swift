//
//  SearchHistoryViewController.swift
//  swift-rindoku-sample
//
//  Created by SCI01557 on 2018/12/27.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit
import RealmSwift

protocol SearchHistoryDelegate {
    func searchHistoryDidTapped(keyword: String)
}

class SearchHistoryViewController: UITableViewController {
    
    let cellId = "reuseIdentifier"
    var realm: Realm = {
        return try! Realm()
    }()

    var currentItems: [SearchHistory] = []
    var histories: Results<SearchHistory>? {
        didSet {
            if let histories = histories {
                currentItems = Array(histories)
                print(currentItems)
            } else {
                currentItems = []
            }
        }
    }
    
    var delegate: SearchHistoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clearsSelectionOnViewWillAppear = false
        let nib = UINib(nibName: "SearchHistoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        histories = realm.objects(SearchHistory.self).sorted(byKeyPath: "searchedAt", ascending: false)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = currentItems.count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchHistoryCell
        let item = currentItems[indexPath.row]
        cell.set(history: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = currentItems[indexPath.row]
        self.delegate?.searchHistoryDidTapped(keyword: item.keyword)
    }
}

extension SearchHistoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let keyword = searchController.searchBar.text {
            currentItems = histories?.filter({ $0.keyword.contains(keyword) }) ?? []
        } else {
            if let histories = histories {
                currentItems = Array(histories)
            } else {
                currentItems = []
            }
        }
        tableView.reloadData()
    }
}
