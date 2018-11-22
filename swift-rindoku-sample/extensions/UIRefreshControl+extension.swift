//
//  UIRefreshControl+extension.swift
//  swift-rindoku-sample
//
//  Created by SCI01557 on 2018/11/15.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    func beginRefreshingManually(in scrollView: UIScrollView) {
        beginRefreshing()
        let offset = CGPoint.init(x: 0, y: -frame.size.height)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    func endRefreshingManually(in scrollView: UIScrollView) {
        endRefreshing()
//        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
}
