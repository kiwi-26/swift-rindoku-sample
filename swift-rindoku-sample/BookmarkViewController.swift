//
//  BookmarkViewController.swift
//  swift-rindoku-sample
//
//  Created by SCI01557 on 2019/01/31.
//  Copyright © 2019年 hicka04. All rights reserved.
//

import UIKit
import GitHubClient
import RealmSwift

class BookmarkViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    let cellId = "cellId"
    
    var realm: Realm = {
        return try! Realm()
    }()
    
    lazy var bookmarks: Results<BookmarkRepository> = {
        return realm.objects(BookmarkRepository.self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bookmark"
        
        tableView.delegate = self
        tableView.dataSource = self
        
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

extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let repository = bookmarks[indexPath.row].repository {
            let detailViewController = DetailViewController(repository: repository)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RepositoryCell
        cell.delegate = self
        if let repository = bookmarks[indexPath.row].repository {
            cell.set(repository: repository)
            cell.setBookmarkButton(bookmarked: bookmarks.contains(where: { $0.repository?.id ?? 0 == repository.id }))
        }
        return cell
    }
}

extension BookmarkViewController: RepositoryCellDelegate {
    func bookmarkButtonDidTap(repositoryId: Int) {
        try! realm.write {
            if let bookmark = realm.objects(BookmarkRepository.self).first(where: { $0.repository?.id ?? 0 == repositoryId }) {
                realm.delete(bookmark)
            }
        }
        //        tableView.reloadData()
    }
}
