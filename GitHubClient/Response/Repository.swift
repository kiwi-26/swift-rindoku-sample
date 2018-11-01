//
//  Repository.swift
//  GitHubClient
//
//  Created by SCI01557 on 2018/10/18.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation

public struct Repository: Decodable {
    public let id: Int
    public let name: String
    public let fullName: String
    public let owner: User
    public let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case htmlUrl = "html_url"
    }
}
