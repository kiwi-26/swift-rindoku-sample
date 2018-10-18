//
//  GitHubAPIError.swift
//  GitHubClient
//
//  Created by SCI01557 on 2018/10/18.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation

struct GitHubAPIError: Decodable, Error {
    struct FieldError: Decodable {
        let resource: String
        let field: String
        let code: String
    }
    
    let message: String
    let fieldErrors: [FieldError]
}
