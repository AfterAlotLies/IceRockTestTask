//
//  MainNavigationController.swift
//  githubRepo
//
//  Created by Vyacheslav on 01.12.2023.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyValue = KeyValueStorage.shared
        
        if let authToken = keyValue.authToken, !authToken.isEmpty {
            print("AuthToken exists and is not empty")
            let navigationController = RepositoriesListViewController(nibName: "RepositoriesListViewController", bundle: nil)
            self.viewControllers = [navigationController]
        } else {
            print("AuthToken is nil or empty")
            let navigationController = AuthenticationViewController(nibName: "AuthenticationViewController", bundle: nil)
            self.viewControllers = [navigationController]
        }
    }
}
