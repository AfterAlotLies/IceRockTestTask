//
//  AuthenticationViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 29.11.2023.
//

import UIKit
import Reachability
import Alamofire

class AuthenticationViewController: UIViewController {
    
    @IBOutlet private weak var imageLogo: UIImageView!
    @IBOutlet private weak var tokenInputField: TokenInputClass!
    @IBOutlet private weak var signInButton: CustomButtonClass!
    @IBOutlet private weak var errorView: ErrorView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternetConnection()
        errorView.delegate = self
        signInUserButton()
        hideKeyBoard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func showOrHideBadConnectionAuthView(response: String) {
        switch response {

        case "success":
            imageLogo.isHidden = false
            tokenInputField.isHidden = false
            signInButton.isHidden = false
            errorView.hideErrorView()

        default:
            imageLogo.isHidden = true
            tokenInputField.isHidden = true
            signInButton.isHidden = true
            errorView.showErrorView()
        }
    }
    
    private func checkInternetConnection() {
        InternetConnection.shared.checkInternetConnection {
            self.showOrHideBadConnectionAuthView(response: "success")
        } failureHandler: {
            self.errorView.setTypeOfPreviousView(type: .authController)
            self.showOrHideBadConnectionAuthView(response: "fail")
        }
    }
    
    private func signInUserButton() {
        signInButton.setButtonText(buttonText: "Sign in")
        signInButton.actionHandler = {
            let token = self.tokenInputField.checkCorrectToken()
            if token == "" {
                self.errorAlert(title: "Error",
                                message: "Enter your personal access token")
            } else {
                InternetConnection.shared.checkInternetConnection {
                    self.authUserInApp(token: token)
                } failureHandler: {
                    let noConnectionItem = {
                        self.errorView.setTypeOfPreviousView(type: .authController)
                        self.showOrHideBadConnectionAuthView(response: "fail")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: noConnectionItem)
                }
            }
        }
    }
    
    private func authUserInApp(token: String) {
        signInButton.startLoading()
        AppRepository.shared.signIn(token: token) { response, error in
            if error != nil {
                if let error = error as? AFError, let errorCode = error.responseCode {
                    switch errorCode {
                    case 401:
                        DispatchQueue.main.async {
                            self.signInButton.stopLoading()
                            self.tokenInputField.displayErrorText()
                        }
                    default:
                        self.errorAlert(title: "Error", message: error.localizedDescription)
                    }
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
