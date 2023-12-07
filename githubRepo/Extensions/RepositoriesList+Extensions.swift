//
//  RepositoriesList+Extensions.swift
//  githubRepo
//
//  Created by Vyacheslav on 06.12.2023.
//

import UIKit

// MARK: - Setup NavigationBar + NavigationRightItem
extension RepositoriesListViewController {
    
    func setupNavBar() {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        navigationItem.backBarButtonItem?.title = ""
        title = "Repositories"
    }
    
    func setupNavigationRightItem() {
        let barButton = UIButton()

        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.setImage(UIImage(named: "logoutImage"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(backToAuthView), for: .touchUpInside)

        barButton.addSubview(backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
    }
}

// MARK: - RepositoriesListViewController + UITableViewDataSource
extension RepositoriesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameRepoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        cell.selectionStyle = .none
        cell.repositoryLabel.text = nameRepoArray[indexPath.row]
        cell.languageLabel.text = languageArray[indexPath.row]
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
        navigationController?.pushViewController(RepositoryDetailInfoViewController(nibName: "RepositoryDetailInfoViewController", bundle: nil), animated: true)
    }
}
