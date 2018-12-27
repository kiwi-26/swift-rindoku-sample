//
//  Repository.swift
//  GitHubClient
//
//  Created by SCI01557 on 2018/10/18.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class Repository: Object, Decodable {
    public dynamic var id = 0
    public dynamic var name = ""
    public dynamic var fullName = ""
    public dynamic var owner: User? = User()
    public dynamic var htmlUrl = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case htmlUrl = "html_url"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: Repository.CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        fullName = try container.decode(String.self, forKey: .fullName)
        owner = try container.decode(User.self, forKey: .owner)
        htmlUrl = try container.decode(String.self, forKey: .htmlUrl)
    }
}
