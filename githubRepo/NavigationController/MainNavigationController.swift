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
        let navigationController = AuthenticationViewController(nibName: "AuthenticationViewController", bundle: nil)
        self.viewControllers = [navigationController]
    }
}
