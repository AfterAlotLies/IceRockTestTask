//
//  AuthenticationViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 29.11.2023.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet private weak var imageLogo: UIImageView!
    @IBOutlet private weak var inputTokenField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputFieldUI()
       // CustomButton().signInButton.titleLabel?.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        CustomButton().loadingIndicator.isHidden = false
//        CustomButton().loadingIndicator.startAnimating()
    }
    
    @IBAction private func signInAction(_ sender: Any) {
        guard let token = inputTokenField.text else { return }
        
        if token == "" {
            makeAlert(title: "Error",
                           message: "Enter your personal access token")
        } else {
            authUserInApp(token: token)
        }
    }
    
    private func authUserInApp(token: String) {
        AppRepository.shared.signIn(token: token) { response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.makeAlert(title: "Error",
                                   message: "\(error?.localizedDescription ?? "something gone wrong")")
                }
            } else {
                let repoUrl = response?.urlRepositories
                let repositoriesListViewController = RepositoriesListViewController(nibName: "RepositoriesListViewController", bundle: nil)
                AppRepository.shared.set(url: repoUrl)
                self.navigationController?.pushViewController(repositoriesListViewController, animated: false)
                self.inputTokenField.text = ""
            }
        }
    }
    
    private func setupInputFieldUI() {
        inputTokenField.leftViewMode = .always
        inputTokenField.layer.borderColor = UIColor.darkGray.cgColor
        inputTokenField.attributedPlaceholder = NSAttributedString(string: "Personal access token",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        inputTokenField.backgroundColor = .clear
    }
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
