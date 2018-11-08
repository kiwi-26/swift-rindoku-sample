//
//  DetailViewController.swift
//  swift-rindoku-sample
//
//  Created by SCI01557 on 2018/09/27.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit
import WebKit
import GitHubClient

class DetailViewController: UIViewController {

    @IBOutlet private weak var webview: WKWebView!
    private let repository: Repository
    
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

        let url = URL(string: repository.htmlUrl)!
        webview.load(URLRequest(url: url))
    }
}
