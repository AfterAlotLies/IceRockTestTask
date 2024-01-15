//
//  RepositoryDetailInfoViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 01.12.2023.
//

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
    private var branchName: String = ""
    private var repositoryName: String = ""
    private var ownerName: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupReadmeErrorView()
        setupLoadingIndicators()
        checkInternetConnection()
        setupNavigationRightItem()
        readmeErrorView.delegate = self
        errorView.delegate = self
    }
    
    public func setChosenRepoId(repoId: Int?, branch: String?, repoName: String?, owner: String?) {
        guard let repoId = repoId, let branch = branch, let repoName = repoName, let owner = owner else { return }
        chosenRepoId = repoId.intToString()
        branchName = branch
        repositoryName = repoName
        ownerName = owner
    }
    
// MARK: - Update view by response

    public func updateViewBasedOnResponse(response: String) {
        switch response {
            
        case "success":
            errorView.hideErrorView()
            readmeErrorView.hideErrorView()
            topRepoInfoView.isHidden = true
            readmeTextView.isHidden = true
            getRepositoryDetail()
            getRepositoryReadme()
            
        default:
            errorView.showErrorView()
            readmeErrorView.hideErrorView()
            topRepoInfoView.isHidden = true
            readmeTextView.isHidden = true
        }
    }
    
//MARK: - Check internet connection

    private func checkInternetConnection() {
        InternetConnection.shared.checkInternetConnection {
            self.updateViewBasedOnResponse(response: "success")
        } failureHandler: {
            self.errorView.setTypeOfPreviousView(type: .repoDetailBadConnection)
            self.updateViewBasedOnResponse(response: "fail")
        }
    }
    
// MARK: - Requests to get data for top view + readme

    private func getRepositoryDetail() {
        self.viewLoadingIndicator.startAnimating()
        AppRepository.shared.getRepository(repoId: chosenRepoId) { response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.errorView.setTypeOfPreviousView(type: .other)
                    self.updateViewBasedOnResponse(response: "fail")
                    self.viewLoadingIndicator.stopAnimating()
                }
            } else {
                guard let repoDetail = response else { return }
                DispatchQueue.main.async {
                    self.setInRepoDetail(repoDetail: repoDetail)
                    self.topRepoInfoView.isHidden = false
                    self.viewLoadingIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func getRepositoryReadme() {
        InternetConnection.shared.checkInternetConnection {
            AppRepository.shared.getRepositoryReadme(ownerName: self.ownerName, repositoryName: self.repositoryName, branchName: self.branchName) { repoReadme, error in
                self.readmeLoadingIndicator.startAnimating()
                if error != nil {
                    if let error = error as? AFError, let errorCode = error.responseCode {
                        switch errorCode {
                            
                        case 404:
                            let noReadmeItem = {
                                self.readmeTextView.text = LocalizedStrings.noReadme
                                self.readmeTextView.textColor = .gray
                                self.readmeTextView.isHidden = false
                                self.readmeLoadingIndicator.stopAnimating()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: noReadmeItem)
                            
                        default:
                            let otherErrorItem = {
                                self.errorView.setTypeOfPreviousView(type: .other)
                                self.readmeTextView.isHidden = true
                                self.readmeErrorView.showErrorView()
                                self.readmeLoadingIndicator.stopAnimating()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: otherErrorItem)
                        }
                    }
                } else {
                    guard let repoInfo = repoReadme else { return }
                    if repoInfo.isEmpty {
                        let emptyReadmeItem = {
                            self.readmeTextView.text = LocalizedStrings.emptyReadme
                            self.readmeTextView.textColor = .gray
                            self.readmeTextView.isHidden = false
                            self.readmeLoadingIndicator.stopAnimating()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: emptyReadmeItem)
                    } else {
                        let readmeItem = {
                            let changedRepoInfo = repoInfo.replacingOccurrences(of: "```", with: "`")
                            let markdownText = SwiftyMarkdown(string: changedRepoInfo)
                            self.readmeTextView.attributedText = markdownText.attributedString()
                            self.readmeTextView.textColor = .white
                            self.readmeTextView.isHidden = false
                            self.readmeLoadingIndicator.stopAnimating()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: readmeItem)
                    }
                }
            }
        } failureHandler: {
            DispatchQueue.main.async {
                self.readmeLoadingIndicator.stopAnimating()
                self.readmeTextView.isHidden = true
                self.readmeErrorView.setTypeOfPreviousView(type: .repoDetailReadmeError)
                self.readmeErrorView.showErrorView()
            }
        }
    }
    
// MARK: - Set data to top view

    private func setInRepoDetail(repoDetail: RepoDetails) {
        if let licenseName = repoDetail.license?.spdx {
            topRepoInfoView.setTopRepositoryDetail(url: repoDetail.githubUrlRepo, license: LocalizedStrings.licenseRepoDetail, licenseName: licenseName)
            topRepoInfoView.setupBottomView(stars: repoDetail.stargazers, forks: repoDetail.forks, watchers: repoDetail.watchers)
        } else {
            topRepoInfoView.setTopRepositoryDetail(url: repoDetail.githubUrlRepo, license: "", licenseName: "")
            topRepoInfoView.hideLicenseView()
            topRepoInfoView.setupBottomView(stars: repoDetail.stargazers, forks: repoDetail.forks, watchers: repoDetail.watchers)
        }
    }
    
// MARK: - Setup methods

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
    
    @objc
    func backToAuthView() {
        KeyValueStorage.shared.deleteAuthToken()
        KeyValueStorage.shared.deleteReposUrl()
        
        let authViewController = AuthenticationViewController(nibName: "AuthenticationViewController", bundle: nil)
        navigationController?.setViewControllers([authViewController], animated: false)
    }
}
