//
//  BookmarkRepository.swift
//  swift-rindoku-sample
//
//  Created by SCI01557 on 2018/12/13.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation
import RealmSwift
import GitHubClient

@objcMembers
class BookmarkRepository: Object {
    dynamic var repository: Repository?
    dynamic var bookmarkedAt: Date = Date()
    
    convenience init(repository: Repository) {
        self.init()
        self.repository = repository
    }
}
