//
//  Repo.swift
//  githubRepo
//
//  Created by Vyacheslav on 17.01.2024.
//

import UIKit

// MARK: - Repo
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

// MARK: - Owner
struct Owner: Codable {
    var login: String
}
