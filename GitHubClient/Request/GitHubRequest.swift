//
//  GitHubRequest.swift
//  GitHubClient
//
//  Created by SCI01557 on 2018/10/18.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation

protocol GitHubRequest {
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var body: Encodable? { get }
}

extension GitHubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
}