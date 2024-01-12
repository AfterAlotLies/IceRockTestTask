//
//  RepositoryDetailInfoViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 01.12.2023.
//

import Foundation
import UIKit
import Alamofire
import SwiftyMarkdown
import NVActivityIndicatorView

class RepositoryDetailInfoViewController: UIViewController {
    
    @IBOutlet private weak var topRepoInfoView: RepositoryDetail!
    @IBOutlet private weak var readmeTextView: UITextView!
    @IBOutlet private weak var errorView: ErrorView!
    
    private let viewLoadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 37, height: 37), type: .circleStrokeSpin, color: .white)
    private let readmeLoadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), type: .circleStrokeSpin, color: .white)
    
    private var readmeErrorView: ErrorView!
    
    private var chosenRepoId: String = ""
    private var branch: String = ""
    private var repositoryName: String = ""
    private var ownerName: String = ""
    
    private var requestItem: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupReadmeErrorView()
        setupLoadingIndicators()
        checkInternetConnection()
        setupNavigationRightItem()
        errorView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func setChosenRepoId(repoId: Int?) {
        guard let repoId = repoId else { return }
        chosenRepoId = repoId.intToString()
    }
    
    public func updateViewBasedOnResponse(response: String) {
        switch response {
            
        case "success":
            errorView.hideErrorView()
            readmeErrorView.hideErrorView()
            topRepoInfoView.isHidden = false
            readmeTextView.isHidden = false
            getRepositoryDetail()
            getRepositoryReadme()
            
        default:
            errorView.showErrorView()
            readmeErrorView.hideErrorView()
            topRepoInfoView.isHidden = true
            readmeTextView.isHidden = true
        }
    }
    
    private func setupLoadingIndicators() {
        view.addSubview(viewLoadingIndicator)
        view.addSubview(readmeLoadingIndicator
        )
        viewLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewLoadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLoadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        readmeLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        readmeLoadingIndicator.isHidden = true
        
        NSLayoutConstraint.activate([
            readmeLoadingIndicator.centerXAnchor.constraint(equalTo: readmeTextView.centerXAnchor),
            readmeLoadingIndicator.topAnchor.constraint(equalTo: readmeTextView.topAnchor, constant: 8)
        ])
    }
    
    private func setupReadmeErrorView() {
        readmeErrorView = ErrorView()
        
        self.view.addSubview(readmeErrorView)
        
        readmeErrorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            readmeErrorView.leadingAnchor.constraint(equalTo: readmeTextView.leadingAnchor),
            readmeErrorView.topAnchor.constraint(equalTo: readmeTextView.topAnchor),
            readmeErrorView.trailingAnchor.constraint(equalTo: readmeTextView.trailingAnchor),
            readmeErrorView.bottomAnchor.constraint(equalTo: readmeTextView.bottomAnchor)
        ])
    }
    
    private func checkInternetConnection() {
        InternetConnection.shared.checkInternetConnection {
            self.updateViewBasedOnResponse(response: "success")
        } failureHandler: {
            self.errorView.setTypeOfPreviousView(type: .repoDetailBadConnection)
            self.updateViewBasedOnResponse(response: "fail")
        }
    }
    
    private func getRepositoryDetail() {
        self.viewLoadingIndicator.startAnimating()
        topRepoInfoView.isHidden = true
        AppRepository.shared.getRepository(repoId: chosenRepoId) { response, error in
            if error != nil {
                self.errorView.setTypeOfPreviousView(type: .other)
                self.updateViewBasedOnResponse(response: "fail")
                self.viewLoadingIndicator.stopAnimating()
            } else {
                guard let repoDetail = response else { return }
                self.setInRepoDetail(repoDetail: repoDetail)
                self.topRepoInfoView.isHidden = false
                self.viewLoadingIndicator.stopAnimating()
            }
        }
    }
    
    private func getRepositoryReadme() {
        InternetConnection.shared.checkInternetConnection {
            AppRepository.shared.getRepositoryReadme(ownerName: self.ownerName, repositoryName: self.repositoryName, branchName: self.branch) { repoReadme, error in
                self.readmeLoadingIndicator.startAnimating()
                if error != nil {
                    if let error = error as? AFError, let errorCode = error.responseCode {
                        switch errorCode {
                            
                        case 404:
                            DispatchQueue.main.async {
                                self.readmeTextView.text = "No README.md"
                                self.readmeTextView.textColor = .gray
                                self.readmeLoadingIndicator.stopAnimating()
                            }
                            
                        default:
                            self.errorView.setTypeOfPreviousView(type: .other)
                            self.readmeTextView.isHidden = true
                            self.readmeErrorView.showErrorView()
                            self.readmeLoadingIndicator.stopAnimating()
                        }
                    }
                } else {
                    guard let repoInfo = repoReadme else { return }
                    if repoInfo.isEmpty || repoInfo == "" {
                        self.readmeTextView.text = "README.md is empty"
                        self.readmeTextView.textColor = .gray
                        self.readmeLoadingIndicator.stopAnimating()
                    } else {
                        let changedRepoInfo = repoInfo.replacingOccurrences(of: "```", with: "`")
                        let markdownText = SwiftyMarkdown(string: changedRepoInfo)
                        self.readmeTextView.attributedText = markdownText.attributedString()
                        self.readmeTextView.textColor = .white
                        self.readmeLoadingIndicator.stopAnimating()
                    }
                }
            }
        } failureHandler: {
            self.readmeLoadingIndicator.stopAnimating()
            self.readmeTextView.isHidden = true
            self.readmeErrorView.setTypeOfPreviousView(type: .repoDetailReadmeError)
            self.readmeErrorView.showErrorView()
        }
    }

    
    private func setInRepoDetail(repoDetail: RepoDetails) {
        
        if let licenseName = repoDetail.license?.name {
            topRepoInfoView.setTopRepositoryDetail(url: repoDetail.githubUrlRepo, license: "License", licenseName: licenseName)
            topRepoInfoView.setupBottomView(stars: repoDetail.stargazers, forks: repoDetail.forks, watchers: repoDetail.watchers)
        } else {
            topRepoInfoView.setTopRepositoryDetail(url: repoDetail.githubUrlRepo, license: "", licenseName: "")
            topRepoInfoView.hideLicenseView()
            topRepoInfoView.setupBottomView(stars: repoDetail.stargazers, forks: repoDetail.forks, watchers: repoDetail.watchers)
        }
    }
    
    @objc
    func backToAuthView() {
        KeyValueStorage.shared.deleteAuthToken()
        KeyValueStorage.shared.deleteReposUrl()
        
        let authViewController = AuthenticationViewController(nibName: "AuthenticationViewController", bundle: nil)
        navigationController?.setViewControllers([authViewController], animated: false)
    }
}
