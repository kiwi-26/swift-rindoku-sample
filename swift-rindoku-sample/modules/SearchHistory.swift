//
//  SearchHistory.swift
//  swift-rindoku-sample
//
//  Created by SCI01557 on 2018/12/13.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class SearchHistory: Object {
    dynamic var keyword = ""
    dynamic var searchedAt: Date = Date()
    
    convenience init(keyword: String) {
        self.init()
        self.keyword = keyword
    }
}
