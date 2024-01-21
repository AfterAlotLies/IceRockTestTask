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
    
    // MARK: -
    private enum Constants {
        static let authController = "AuthenticationViewController"
        static let logoutImage = "logoutImage"
        static let viewIndicatorPosX: CGFloat = 0
        static let viewIndicatorPosY: CGFloat = 0
        static let viewIndicatorWidth: CGFloat = 37
        static let viewIndicatorHeight: CGFloat = 37
        static let readmeIndicatorPosX: CGFloat = 0
        static let readmeIndicatorPosY: CGFloat = 0
        static let readmeIndicatorWidth: CGFloat = 20
        static let readmeIndicatorHeight: CGFloat = 20
    }
    
    private let viewLoadingIndicator = NVActivityIndicatorView(frame: CGRect(x: Constants.viewIndicatorPosX,
                                                                             y: Constants.viewIndicatorPosY,
                                                                             width: Constants.viewIndicatorWidth,
                                                                             height: Constants.viewIndicatorHeight),
                                                               type: .circleStrokeSpin,
                                                               color: .white)
    private let readmeLoadingIndicator = NVActivityIndicatorView(frame: CGRect(x: Constants.readmeIndicatorPosX,
                                                                               y: Constants.readmeIndicatorPosY,
                                                                               width: Constants.readmeIndicatorWidth,
                                                                               height: Constants.readmeIndicatorHeight),
                                                                 type: .circleStrokeSpin,
                                                                 color: .white)
    
    private var readmeErrorView: ErrorView!
    
    private var chosenRepoId: String = ""
    private var branchName: String = ""
    private var repositoryName: String = ""
    private var ownerName: String = ""
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupReadmeErrorView()
        setupLoadingIndicators()
        checkInternetConnection()
        setupNavigationRightItem()
        readmeErrorView.delegate = self
        errorView.delegate = self
    }
    
    // MARK: -
    func setChosenRepoId(repoId: Int?, branch: String?, repoName: String?, owner: String?) {
        guard let repoId = repoId, 
              let branch = branch,
              let repoName = repoName,
              let owner = owner
        else { return }
        chosenRepoId = repoId.intToString()
        branchName = branch
        repositoryName = repoName
        ownerName = owner
    }
    
    /// Update view by response
    func updateViewBasedOnResponse(response: ResponseViewStatus) {
        switch response {
        case .success:
            errorView.setErrorViewHidden(true)
            readmeErrorView.setErrorViewHidden(true)
            topRepoInfoView.isHidden = true
            readmeTextView.isHidden = true
            getRepositoryDetail()
        default:
            errorView.showErrorView()
            readmeErrorView.setErrorViewHidden(true)
            topRepoInfoView.isHidden = true
            readmeTextView.isHidden = true
        }
    }
    
    //MARK: - Check internet connection
    private func checkInternetConnection() {
        InternetConnectionManager.shared.checkInternetConnection {
            self.updateViewBasedOnResponse(response: .success)
        } failureHandler: {
            self.errorView.setTypeOfPreviousView(type: .repoDetailBadConnection)
            self.updateViewBasedOnResponse(response: .fail)
        }
    }
    
    // MARK: - Requests to get data for top view + readme
    private func getRepositoryDetail() {
        self.viewLoadingIndicator.startAnimating()
        AppRepository.shared.getRepository(repoId: chosenRepoId) { response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.viewLoadingIndicator.stopAnimating()
                    self.errorView.setTypeOfPreviousView(type: .other)
                    self.updateViewBasedOnResponse(response: .fail)
                }
            } else {
                guard let repoDetail = response else { return }
                DispatchQueue.main.async {
                    self.viewLoadingIndicator.stopAnimating()
                    self.setInRepoDetail(repoDetail: repoDetail)
                    self.topRepoInfoView.isHidden = false
                    self.getRepositoryReadme()
                }
            }
        }
    }
    
    private func getRepositoryReadme() {
        InternetConnectionManager.shared.checkInternetConnection {
            AppRepository.shared.getRepositoryReadme(ownerName: self.ownerName,
                                                     repositoryName: self.repositoryName,
                                                     branchName: self.branchName) { repoReadme, error in
                if error != nil {
                    if let error = error as? AFError, let errorCode = error.responseCode {
                        self.readmeLoadingIndicator.startAnimating()
                        switch errorCode {
                            
                        case 404:
                            let noReadmeItem = {
                                self.setReadmeText(readmeText: LocalizedStrings.noReadme)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: noReadmeItem)
                            
                        default:
                            let otherErrorItem = {
                                self.setReadmeOtherError()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: otherErrorItem)
                        }
                    }
                } else {
                    guard let repoInfo = repoReadme else { return }
                    self.readmeLoadingIndicator.startAnimating()
                    if repoInfo.isEmpty {
                        let emptyReadmeItem = {
                            self.setReadmeText(readmeText: LocalizedStrings.emptyReadme)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: emptyReadmeItem)
                    } else {
                        let readmeItem = {
                            self.setReadmeData(repoInfo: repoInfo)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: readmeItem)
                    }
                }
            }
        } failureHandler: {
            DispatchQueue.main.async {
                self.setReadmeError()
            }
        }
    }
    
    // MARK: - Actions with readme (errors/success)
    private func setReadmeText(readmeText: String) {
        readmeLoadingIndicator.stopAnimating()
        readmeTextView.text = readmeText
        readmeTextView.textColor = .gray
        readmeTextView.isHidden = false
    }
    
    private func setReadmeData(repoInfo: String) {
        self.readmeLoadingIndicator.stopAnimating()
        let changedRepoInfo = repoInfo.replacingOccurrences(of: "```", with: "`")
        let markdownText = SwiftyMarkdown(string: changedRepoInfo)
        self.readmeTextView.attributedText = markdownText.attributedString()
        self.readmeTextView.textColor = .white
        self.readmeTextView.isHidden = false
    }
    
    private func setReadmeError() {
        readmeLoadingIndicator.stopAnimating()
        readmeErrorView.setTypeOfPreviousView(type: .repoDetailReadmeError)
        readmeTextView.isHidden = true
        readmeErrorView.showErrorView()
    }
    
    private func setReadmeOtherError() {
        readmeLoadingIndicator.stopAnimating()
        errorView.setTypeOfPreviousView(type: .other)
        readmeTextView.isHidden = true
        readmeErrorView.showErrorView()
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
    
    @objc
    private func backToAuthView() {
        KeyValueStorage.shared.deleteAuthToken()
        KeyValueStorage.shared.deleteReposUrl()
        
        let authViewController = AuthenticationViewController(nibName: Constants.authController, bundle: nil)
        navigationController?.setViewControllers([authViewController], animated: false)
    }
}

// MARK: - Setup Methods
private extension RepositoryDetailInfoViewController {
    
    func setupNavigationRightItem() {
        let barButton = UIButton()
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.setImage(UIImage(named: Constants.logoutImage), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        
        backButton.addTarget(self,
                             action: #selector(backToAuthView),
                             for: .touchUpInside)
        
        barButton.addSubview(backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
    }
    
    func setupLoadingIndicators() {
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
    
    func setupReadmeErrorView() {
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
}

// MARK: - RepositoryDetailInfoViewController + ErrorViewDelegate
extension RepositoryDetailInfoViewController: ErrorViewDelegate {
    
    func retryConnectToInternet() {
        updateViewBasedOnResponse(response: .success)
    }
}
