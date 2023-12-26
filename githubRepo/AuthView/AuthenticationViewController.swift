//
//  AuthenticationViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 29.11.2023.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet private weak var imageLogo: UIImageView!
    @IBOutlet private weak var tokenInputField: TokenInputClass!
    @IBOutlet private weak var signInButton: CustomButtonClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInUserButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func signInUserButton() {
        signInButton.actionHandler = {
            let token = self.tokenInputField.checkCorrectToken()
            if token == "" {
                self.errorAlert(title: "Error",
                               message: "Enter your personal access token")
            } else {
                self.authUserInApp(token: token)
            }
        }
    }
    
    private func authUserInApp(token: String) {
        signInButton.startLoading()
        AppRepository.shared.signIn(token: token) { response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.signInButton.stopLoading()
                    self.tokenInputField.displayErrorText()
                }
            } else {
                let workItem = DispatchWorkItem {
                    self.signInButton.stopLoading()
                    let repoUrl = response?.urlRepositories
                    let repositoriesListViewController = RepositoriesListViewController(nibName: "RepositoriesListViewController", bundle: nil)
                    AppRepository.shared.setAuthUrl(url: repoUrl)
                    self.navigationController?.pushViewController(repositoriesListViewController, animated: false)
                    self.tokenInputField.clearTextField()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
            }
        }
    }
    
    private func errorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
