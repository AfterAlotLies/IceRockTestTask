//
//  ControllerType.swift
//  githubRepo
//
//  Created by Vyacheslav on 21.01.2024.
//

// MARK: - ControllerType
enum ControllerType: String {
    
    case authController = "authController"
    case repoListBadConnection = "repoListBadConnection"
    case repoListEmpty = "repoListEmpty"
    case repoDetailBadConnection = "repoDetailBadConnection"
    case repoDetailReadmeError = "repoDetailReadmeError"
    case other = "other"
}
