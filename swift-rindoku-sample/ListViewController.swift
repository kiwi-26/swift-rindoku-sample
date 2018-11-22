//
//  ViewController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2018/08/11.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit
import GitHubClient

class ListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    let cellId = "cellId"
    
    var data: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshingManually(in: self.tableView)
            }
        }
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "キーワードを入力"
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
        cell.set(repositoryName: data[indexPath.row].fullName)
        return cell
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyword = searchBar.text ?? ""
        searchController.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        keyword = ""
        searchController.dismiss(animated: true, completion: nil)
    }
}
