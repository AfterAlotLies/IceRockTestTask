//
//  MainNavigationController.swift
//  githubRepo
//
//  Created by Vyacheslav on 01.12.2023.
//

import UIKit
import Reachability

// MARK: -
class MainNavigationController: UINavigationController {
    
    private let keyValue = KeyValueStorage.shared
    
    // MARK: -
    private enum Constants {
        static let authController = "AuthenticationViewController"
        static let repoListController = "RepositoriesListViewController"
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authToken = keyValue.authToken, !authToken.isEmpty {
            setRepoListMain()
        } else {
            setAuthViewMain()
        }
    }
    
    // MARK: -
    private func setAuthViewMain() {
        let navigationController = AuthenticationViewController(nibName: Constants.authController, bundle: nil)
        self.viewControllers = [navigationController]
    }
    
    private func setRepoListMain() {
        let navigationController = RepositoriesListViewController(nibName: Constants.repoListController, bundle: nil)
        self.viewControllers = [navigationController]
    }
}
