//
//  User.swift
//  GitHubClient
//
//  Created by SCI01557 on 2018/10/18.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class User: Object, Decodable {
    dynamic var id = 0
    dynamic var login = ""
}
