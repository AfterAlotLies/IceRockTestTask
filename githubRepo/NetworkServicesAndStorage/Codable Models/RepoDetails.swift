//
//  RepoDetail.swift
//  githubRepo
//
//  Created by Vyacheslav on 17.01.2024.
//

import UIKit

struct RepoDetails: Codable {

    private enum CodingKeys: String, CodingKey {
        case githubUrlRepo = "html_url"
        case license
        case stargazers = "stargazers_count"
        case watchers = "watchers_count"
        case forks = "forks_count"

    }
    var githubUrlRepo: String
    var license: License?
    var stargazers: Int
    var forks: Int
    var watchers: Int
}

struct License: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case spdx = "spdx_id"
    }
    var spdx: String
}
