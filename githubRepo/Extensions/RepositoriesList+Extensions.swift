//
//  RepositoriesList+Extensions.swift
//  githubRepo
//
//  Created by Vyacheslav on 06.12.2023.
//

import UIKit

private enum Constants {
    static let repoListCellsUI = "RepositoriesListCellsUI"
    static let repoListController = "RepositoryDetailInfoViewController"
}

// MARK: - RepositoriesListViewController + UITableViewDataSource
extension RepositoriesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameRepoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.repoListCellsUI) as! RepositoriesListCells
        cell.setFontToLabels()
        cell.setRepoName(repoName: nameRepoArray[indexPath.row])
        cell.setLanguage(language: languageArray[indexPath.row])
        cell.selectionStyle = .none
        if descriptionArray[indexPath.row] == "" {
            cell.hideDescriptionLabel()
        } else {
            cell.setDescriptionRepo(description: descriptionArray[indexPath.row])
        }
        return cell
    }
}

// MARK: - RepositoriesListViewController + UITableViewDelegate
extension RepositoriesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryDetail = RepositoryDetailInfoViewController(nibName: Constants.repoListController, bundle: nil)
        repositoryDetail.setChosenRepoId(repoId: reposIdArray[indexPath.row], branch: branchArray[indexPath.row],
                                         repoName: nameRepoArray[indexPath.row], owner: ownerNameArray[indexPath.row])
        repositoryDetail.navigationItem.title = nameRepoArray[indexPath.row]
        navigationController?.pushViewController(repositoryDetail, animated: true)
    }
}

// MARK: - RepositoriesListViewController + ErrorViewDelegate
extension RepositoriesListViewController: ErrorViewDelegate {
    
    func retryConnectToInternet() {
        updateViewBasedOnResponse(response: .success)
    }
    
    func retryToGetRepoList() {
        retryToGetRepositories()
    }
}
