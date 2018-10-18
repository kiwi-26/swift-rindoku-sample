//
//  GitHubClientError.swift
//  GitHubClient
//
//  Created by SCI01557 on 2018/10/18.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation

enum GitHubClientError: Error {
    case connectionError(Error)
    case responseParseError(Error)
    case apiError(GitHubAPIError)
}
