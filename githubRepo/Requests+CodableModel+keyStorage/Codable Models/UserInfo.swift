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

    private enum CodingKeys: String, CodingKey {
        case name
        case language
        case description
        case id
        case owner
        case branch = "default_branch"
    }
    var name: String
    var language: String?
    var description: String?
    var id: Int
    var owner: Owner
    var branch: String
}



struct Owner: Codable {
    var login: String
}
