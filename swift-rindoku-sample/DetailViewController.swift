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
    @IBOutlet private weak var progressView: UIProgressView!
    
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
        webview.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webview.load(URLRequest(url: url))
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.setProgress(Float(webview.estimatedProgress), animated: true)
        }else if keyPath == "loading"{
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.webview.isLoading
            if webview.isLoading {
                progressView.setProgress(0.1, animated: true)
            }else{
                progressView.setProgress(0.0, animated: false)
            }
        }
    }
}
