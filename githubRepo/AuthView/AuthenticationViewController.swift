//
//  AuthenticationViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 29.11.2023.
//

import UIKit
import Alamofire

class AuthenticationViewController: UIViewController {
    
    @IBOutlet private weak var imageLogo: UIImageView!
    @IBOutlet private weak var tokenInputField: TokenInput!
    @IBOutlet private weak var signInButton: MultiPurposeButton!
    @IBOutlet private weak var errorView: ErrorView!
    
    private enum Constants {
        static let repoListController = "RepositoriesListViewController"
        static let alertTitle = "OK"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternetConnection()
        errorView.delegate = self
        signInUserButton()
        hideKeyBoard()
    }
    
// MARK: - Update view by response
    func updateViewBasedOnResponse(response: ResponseViewStatus) {
        switch response {

        case .success:
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
    
// MARK: - Check internet connection
    private func checkInternetConnection() {
        InternetConnectionManager.shared.checkInternetConnection {
            self.updateViewBasedOnResponse(response: .success)
        } failureHandler: {
            self.errorView.setTypeOfPreviousView(type: .authController)
            self.updateViewBasedOnResponse(response: .fail)
        }
    }
    
// MARK: - Setup button + check correctly token
    private func signInUserButton() {
        signInButton.setButtonText(buttonText: LocalizedStrings.buttonAuthController)
        signInButton.setActionOnButton { [weak self] in
            guard let self = self else { return }
            let token = tokenInputField.checkCorrectToken()
            if token == "" {
                errorAlert(title: LocalizedStrings.titleAlert,
                           message: LocalizedStrings.messageAlert)
            } else {
                self.signInButton.startLoading()
                InternetConnectionManager.shared.checkInternetConnection {
                    self.authUserInApp(token: token)
                } failureHandler: {
                    let noConnectionItem = {
                        self.errorView.setTypeOfPreviousView(type: .authController)
                        self.updateViewBasedOnResponse(response: .fail)
                        self.signInButton.stopLoading()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: noConnectionItem)
                }
            }
        }
    }
    
// MARK: - Request to auth by token
    private func authUserInApp(token: String) {
        AppRepository.shared.signIn(token: token) { [weak self] response, error in
            guard let self = self else { return }
            if error != nil {
                if let error = error as? AFError, let errorCode = error.responseCode {
                    switch errorCode {
                    case 401:
                        DispatchQueue.main.async {
                            self.signInButton.stopLoading()
                            self.tokenInputField.displayErrorText()
                        }
                    default:
                        self.errorAlert(title: LocalizedStrings.titleAlert, message: error.localizedDescription)
                    }
                }
            } else {
                let workItem = DispatchWorkItem {
                    self.signInButton.stopLoading()
                    let repoUrl = response?.urlRepositories
                    let repositoriesListViewController = RepositoriesListViewController(nibName: Constants.repoListController, bundle: nil)
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
        let okButton = UIAlertAction(title: Constants.alertTitle, style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}

// MARK: - Hide keyboard by tap
private extension AuthenticationViewController {
    
    private func hideKeyBoard() {
        let hideKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardTap)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
}
