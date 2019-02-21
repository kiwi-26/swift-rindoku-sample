//
//  DetailViewController.swift
//  swift-rindoku-sample
//
//  Created by SCI01557 on 2018/09/27.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift
import GitHubClient

class DetailViewController: UIViewController {

    @IBOutlet private weak var webview: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var progressViewHeightConstraint: NSLayoutConstraint!
    
    private let repository: Repository
    
    var realm: Realm = {
        return try! Realm()
    }()
    
    init(repository: Repository) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = repository.fullName

        if realm.objects(BookmarkRepository.self).first(where: { (repo) -> Bool in
            return repo.repository?.id == self.repository.id
        }) != nil {
            let bookmarkButton = UIBarButtonItem(image: UIImage(named: "round_bookmark_black_24pt"), style: .plain, target: self, action: #selector(bookmarkButtonDidTapped))
            navigationItem.rightBarButtonItem = bookmarkButton
        } else {
            let bookmarkButton = UIBarButtonItem(image: UIImage(named: "round_bookmark_border_black_24pt"), style: .plain, target: self, action: #selector(bookmarkButtonDidTapped))
            navigationItem.rightBarButtonItem = bookmarkButton
        }
        
        let url = URL(string: repository.htmlUrl)!
        webview.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webview.load(URLRequest(url: url))
    }
    
    @objc func bookmarkButtonDidTapped () {
        try! realm.write {
            if let bookmark = realm.objects(BookmarkRepository.self).first(where: { $0.repository?.id == self.repository.id }) {
                realm.delete(bookmark)
                let bookmarkButton = UIBarButtonItem(image: UIImage(named: "round_bookmark_border_black_24pt"), style: .plain, target: self, action: #selector(bookmarkButtonDidTapped))
                navigationItem.rightBarButtonItem = bookmarkButton
            } else {
                guard realm.objects(BookmarkRepository.self).count < 50 else {
                    let alert = UIAlertController(title: "お気に入りがいっぱいです", message: "お気に入りの保存は50件までです", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return
                }
                realm.add(BookmarkRepository(repository: self.repository))
                let bookmarkButton = UIBarButtonItem(image: UIImage(named: "round_bookmark_black_24pt"), style: .plain, target: self, action: #selector(bookmarkButtonDidTapped))
                navigationItem.rightBarButtonItem = bookmarkButton
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.setProgress(Float(webview.estimatedProgress), animated: true)
        }else if keyPath == "loading"{
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.webview.isLoading
            if webview.isLoading {
                progressView.setProgress(0.1, animated: true)
                progressViewHeightConstraint.constant = 2
            }else{
                progressView.setProgress(0.0, animated: false)
                progressViewHeightConstraint.constant = 0
            }
        }
    }
}
