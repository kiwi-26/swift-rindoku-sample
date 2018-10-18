//
//  Repository.swift
//  GitHubClient
//
//  Created by SCI01557 on 2018/10/18.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let name: String
    let fullName: String
    let owner: User
    let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case htmlUrl = "html_url"
    }
}
