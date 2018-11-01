//
//  GitHubAPI.swift
//  GitHubClient
//
//  Created by SCI01557 on 2018/10/18.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation

public final class GitHubAPI {
    public struct SearchRepositories: GitHubRequest {
        public let keyword: String
        public var body: Encodable?

        public typealias Response = SearchResponse<Repository>
        
        public init(keyword: String) {
            self.keyword = keyword
        }
        
        public var method: HTTPMethod {
            return .get
        }
        
        public var path: String {
            return "/search/repositories"
        }
        
        public var queryItems: [URLQueryItem] {
            return [URLQueryItem(name: "q", value: keyword)]
        }
    }
    
    public struct SearchUsers: GitHubRequest {
        public let keyword: String
        public var body: Encodable?
        
        public typealias Response = SearchResponse<User>
        
        public var method: HTTPMethod {
            return .get
        }
        
        public var path: String {
            return "/search/users"
        }
        
        public var queryItems: [URLQueryItem] {
            return [URLQueryItem(name: "q", value: keyword)]
        }
    }
}
