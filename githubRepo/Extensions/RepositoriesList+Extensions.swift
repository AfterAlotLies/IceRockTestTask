//
//  RepositoriesList+Extensions.swift
//  githubRepo
//
//  Created by Vyacheslav on 06.12.2023.
//

import UIKit

// MARK: - RepositoriesListViewController + ErrorViewDelegate
extension RepositoriesListViewController: ErrorViewDelegate {
    
    func retryConnectToInternet() {
        updateViewBasedOnResponse(response: .success)
    }
    
    func retryToGetRepoList() {
        retryToGetRepositories()
    }
}
