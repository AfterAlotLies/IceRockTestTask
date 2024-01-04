//
//  MainNavigationController.swift
//  githubRepo
//
//  Created by Vyacheslav on 01.12.2023.
//

import UIKit
import Reachability

class MainNavigationController: UINavigationController {
    
    private let internetConnection = InternetConnection.shared.internetConnection
    private let keyValue = KeyValueStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authToken = keyValue.authToken, !authToken.isEmpty {
            setRepoListMain()
        } else {
            setAuthViewMain()
        }
    }
    
    private func setAuthViewMain() {
        let navigationController = AuthenticationViewController(nibName: "AuthenticationViewController", bundle: nil)
        self.viewControllers = [navigationController]
    }
    
    private func setRepoListMain() {
        let navigationController = RepositoriesListViewController(nibName: "RepositoriesListViewController", bundle: nil)
        self.viewControllers = [navigationController]
    }
}
