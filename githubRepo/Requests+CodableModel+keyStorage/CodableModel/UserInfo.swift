//
//  UserInfoModel.swift
//  githubRepo
//
//  Created by Vyacheslav on 05.12.2023.
//

import UIKit

struct UserInfo: Codable {

    private enum CodingKeys: String, CodingKey {
        case urlRepositories = "repos_url"
    }
    var urlRepositories: String
}

struct Repo: Codable {

    var name: String
    var language: String?
    var description: String?
    var id: Int
}

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
    var name: String?
}
