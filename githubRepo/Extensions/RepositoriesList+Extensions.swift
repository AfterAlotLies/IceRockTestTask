//
//  RepositoriesList+Extensions.swift
//  githubRepo
//
//  Created by Vyacheslav on 06.12.2023.
//

import UIKit

// MARK: - Setup View
extension RepositoriesListViewController {
    
    func setupNavBar() {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        navigationItem.backBarButtonItem?.title = ""
        title = LocalizedStrings.repoListTitle
    }
    
    func setupNavigationRightItem() {
        let barButton = UIButton()

        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.setImage(UIImage(named: "logoutImage"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        
        backButton.addTarget(self,
                             action: #selector(backToAuthView),
                             for: .touchUpInside)

        barButton.addSubview(backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
    }
}

// MARK: - RepositoriesListViewController + UITableViewDataSource
extension RepositoriesListViewController: UITableViewDataSource {
    
    private enum Languages: String {
        case swift = "Swift"
        case c_first = "C"
        case c_second = "C++"
        case c_third = "C#"
        case kotlin = "Kotlin"
        case java = "Java"
        case python = "Python"
        case html = "HTML"
        case javascript = "JavaScript"
        
        var labelColor: UIColor {
               switch self {
               case .swift:
                   return .orange
               case .c_first, .c_second, .c_third:
                   return .cyan
               case .kotlin:
                   return .purple
               case .java:
                   return .red
               case .python:
                   return .green
               case .html:
                   return .brown
               case .javascript:
                   return .yellow
               }
           }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameRepoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        cell.selectionStyle = .none
        cell.repositoryLabel.text = nameRepoArray[indexPath.row]
        cell.languageLabel.text = languageArray[indexPath.row]
        cell.languageLabel.textColor = Languages(rawValue: languageArray[indexPath.row])?.labelColor ?? .white
        if descriptionArray[indexPath.row] == "" {
            cell.descriptionLabel.isHidden = true
        } else {
            cell.descriptionLabel.text = descriptionArray[indexPath.row]
        }
        return cell
    }
}

// MARK: - RepositoriesListViewController + UITableViewDelegate
extension RepositoriesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryDetail = RepositoryDetailInfoViewController(nibName: "RepositoryDetailInfoViewController", bundle: nil)
        repositoryDetail.setChosenRepoId(repoId: reposIdArray[indexPath.row], branch: branchArray[indexPath.row],
                                         repoName: nameRepoArray[indexPath.row], owner: ownerNameArray[indexPath.row])
        repositoryDetail.navigationItem.title = nameRepoArray[indexPath.row]
        navigationController?.pushViewController(repositoryDetail, animated: true)
    }
}

// MARK: - RepositoriesListViewController + ErrorViewDelegate
extension RepositoriesListViewController: ErrorViewDelegate {
    
    func retryConnectToInternet() {
        updateViewBasedOnResponse(response: "success")
    }
    
    func retryToGetRepoList() {
        retryToGetRepositories()
    }
}
