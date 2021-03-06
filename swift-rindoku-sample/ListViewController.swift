//
//  ViewController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2018/08/11.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit
import GitHubClient
import RealmSwift

protocol RepositoryCellDelegate {
    func bookmarkButtonDidTap(repositoryId: Int)
}

class ListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    let cellId = "cellId"
    
    var realm: Realm = {
        return try! Realm()
    }()
    
    var data: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshingManually(in: self.tableView)
            }
        }
    }
    
    var notificationToken: NotificationToken? = nil
    lazy var bookmarks: Results<BookmarkRepository> = {
        let results = realm.objects(BookmarkRepository.self)
        notificationToken = results.observe({ [weak self] (changes: RealmCollectionChange<Results<BookmarkRepository>>) in
            self?.tableView.reloadData()
        })
        return results
    }()
    
    private let searchHistoryController = SearchHistoryViewController(style: .plain)
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchHistoryController)
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "キーワードを入力"
        searchController.searchResultsUpdater = searchHistoryController
        searchHistoryController.delegate = self
        return searchController
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: CGRect.zero)
        refreshControl.addTarget(self, action: #selector(ListViewController.search), for: .valueChanged)
        return refreshControl
    }()
    
    var keyword: String = "" {
        didSet {
            self.search()
            if !keyword.isEmpty {
                try! realm.write {
                    if let history = realm.objects(SearchHistory.self).first(where: { $0.keyword == keyword }) {
                        history.searchedAt = Date()
                    } else {
                        realm.add(SearchHistory(keyword: keyword))
                    }
                }
            }
            
            if searchController.searchBar.text?.isEmpty ?? true {
                searchController.searchBar.text = keyword
            }
        }
    }
    
    @objc func search() {
        guard !keyword.isEmpty else {
            self.data = []
            return
        }
        
        let client = GitHubClient()
        let request = GitHubAPI.SearchRepositories(keyword: keyword)
        self.refreshControl.beginRefreshingManually(in: self.tableView)
        
        client.send(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.data = response.items
            case .failure(_):
                self?.data = []
                let controller = UIAlertController(title: "エラー", message: "エラーが発生しました", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
                self?.present(controller, animated: true, completion: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GitHub Search"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = refreshControl
        
        // 検索バー設定
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        let nib = UINib(nibName: "RepositoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        let history = realm.objects(SearchHistory.self).sorted(byKeyPath: "searchedAt", ascending: false)
        keyword = history.first?.keyword ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(repository: data[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RepositoryCell
        let repository = data[indexPath.row]
        cell.delegate = self
        cell.set(repository: repository)
        cell.setBookmarkButton(bookmarked: bookmarks.contains(where: { $0.repository?.id ?? 0 == repository.id }))
        return cell
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyword = searchBar.text ?? ""
        searchController.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true, completion: { () in
            searchBar.text = self.keyword
        })
    }
}

extension ListViewController: SearchHistoryDelegate {
    func searchHistoryDidTapped(keyword: String) {
        searchController.searchBar.text = keyword
    }
}

extension ListViewController: RepositoryCellDelegate {
    func bookmarkButtonDidTap(repositoryId: Int) {
        if let repository = data.first(where: { $0.id == repositoryId }) {
            try! realm.write {
                if let bookmark = realm.objects(BookmarkRepository.self).first(where: { $0.repository?.id ?? 0 == repositoryId }) {
                    realm.delete(bookmark)
                } else {
                    guard realm.objects(BookmarkRepository.self).count < 50 else {
                        let alert = UIAlertController(title: "お気に入りがいっぱいです", message: "お気に入りの保存は50件までです", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        present(alert, animated: true, completion: nil)
                        return
                    }

                    realm.add(BookmarkRepository(repository: repository))
                }
            }
            tableView.reloadData()
        }
    }
}
