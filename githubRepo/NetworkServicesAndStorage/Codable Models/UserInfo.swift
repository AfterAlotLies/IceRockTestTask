//
//  UserInfoModel.swift
//  githubRepo
//
//  Created by Vyacheslav on 05.12.2023.
//

import UIKit

// MARK: -
struct UserInfo: Codable {

    private enum CodingKeys: String, CodingKey {
        case urlRepositories = "repos_url"
    }
    var urlRepositories: String
}
