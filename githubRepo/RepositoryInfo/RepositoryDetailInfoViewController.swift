//
//  RepositoryDetailInfoViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 01.12.2023.
//

import UIKit
import Alamofire
import MarkdownKit
import SwiftyMarkdown

class RepositoryDetailInfoViewController: UIViewController {
    
    @IBOutlet private weak var topRepoInfoView: RepositoryDetail!
    @IBOutlet private weak var readmeTextView: UITextView!
    @IBOutlet private weak var errorView: ErrorView!
    
    private var readmeErrorView: ErrorView!
    
    private var chosenRepoId: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupReadmeErrorView()
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
    
    public func showOrHideErrorViewRepositoryDetail(response: String) {
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
            self.showOrHideErrorViewRepositoryDetail(response: "success")
        } failureHandler: {
            self.errorView.setTypeOfPreviousView(type: .repoDetailBadConnection)
            self.showOrHideErrorViewRepositoryDetail(response: "fail")
        }
    }
    
    private func getRepositoryDetail() {
        AppRepository.shared.getRepository(repoId: chosenRepoId) { response, error in
            if error != nil {
                self.errorView.setTypeOfPreviousView(type: .other)
                self.showOrHideErrorViewRepositoryDetail(response: "fail")
            } else {
                guard let repoDetail = response else { return }
                self.setInRepoDetail(repoDetail: repoDetail)
            }
        }
    }
    
    //полное говно не знаю как правильно это сделать ----- задать вопрос как правильно отображать ошибку про ридми
    private func getRepositoryReadme() {
        InternetConnection.shared.checkInternetConnection {
            AppRepository.shared.getRepositoryReadme(ownerName: "", repositoryName: "", branchName: "") { repoReadme, error in
                if error != nil {
                    if let error = error as? AFError, let errorCode = error.responseCode {
                        switch errorCode {

                        case 404:
                            DispatchQueue.main.async {
                                self.readmeTextView.text = "No README.md"
                                self.readmeTextView.textColor = .gray
                            }

                        default:
                            self.errorView.setTypeOfPreviousView(type: .other)
                            self.readmeTextView.isHidden = true
                            self.readmeErrorView.showErrorView()
                        }
                    }
                } else {
                    guard let repoInfo = repoReadme else { return }
                    if repoInfo.isEmpty || repoInfo == "" {
                        self.readmeTextView.text = "README.md is empty"
                        self.readmeTextView.textColor = .gray
                    } else {
                        let changedRepoInfo = repoInfo.replacingOccurrences(of: "```", with: "`")
                        let markdownText = SwiftyMarkdown(string: changedRepoInfo)
                        self.readmeTextView.attributedText = markdownText.attributedString()
                        self.readmeTextView.textColor = .white
                    }
                }
            }
        } failureHandler: {
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
