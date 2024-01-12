//
//  RepositoriesListViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 29.11.2023.
//

import UIKit
import NVActivityIndicatorView

class RepositoriesListViewController: UIViewController {

    @IBOutlet private weak var repoList: UITableView!
    @IBOutlet private weak var errorView: ErrorView!
    
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 37, height: 37), type: .circleStrokeSpin, color: .white)
    
    var nameRepoArray = [String]()
    var languageArray = [String]()
    var descriptionArray = [String]()
    var reposIdArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationRightItem()
        setupNavBar()
        setupView()
        setupLoaderIndicator()
        checkInternetConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func updateViewBasedOnResponse(response: String) {
        switch response {
            
        case "success":
            
            repoList.isHidden = false
            loadingIndicator.isHidden = false
            errorView.hideErrorView()
            getUserRepositories()
            
        default:
            repoList.isHidden = true
            loadingIndicator.isHidden = true
            errorView.showErrorView()
        }
    }
    
    public func retryToGetRepositories() {
        checkInternetConnection()
    }
    
    private func setupLoaderIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loadingIndicator.startAnimating()
    }
    
    private func checkInternetConnection() {
        InternetConnection.shared.checkInternetConnection {
            self.updateViewBasedOnResponse(response: "success")
        } failureHandler: {
            self.errorView.setTypeOfPreviousView(type: .repoListBadConnection)
            self.updateViewBasedOnResponse(response: "fail")
        }
    }
    
    private func getUserRepositories() {
        clearAllArrays()
        
        if loadingIndicator.isHidden == true {
            loadingIndicator.isHidden = false
        }
        
        loadingIndicator.startAnimating()
        AppRepository.shared.getRepositories { repoDetail, error in
            if error != nil {
                self.errorView.setTypeOfPreviousView(type: .other)
                self.updateViewBasedOnResponse(response: "fail")
            } else {
                guard let repositoryDetail = repoDetail else { return }
                for detail in repositoryDetail {
                    self.addInfoToArrays(detail: detail)
                }
                DispatchQueue.main.async {
                    if !self.nameRepoArray.isEmpty {
                        self.errorView.hideErrorView()
                        self.repoList.isHidden = false
                        self.repoList.reloadData()
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                    } else {
                        self.errorView.setTypeOfPreviousView(type: .repoListEmpty)
                        self.updateViewBasedOnResponse(response: "empty")
                    }
                }
            }
        }
    }
    
    private func setupView() {
        repoList.dataSource = self
        repoList.delegate = self
        errorView.delegate = self
        repoList.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        repoList.separatorInset = UIEdgeInsets.zero
        loadingIndicator.isHidden = false
        navigationItem.backButtonTitle = ""
    }
    
    private func addInfoToArrays(detail: Repo) {
        nameRepoArray.append(detail.name)
        languageArray.append(detail.language ?? "")
        descriptionArray.append(detail.description ?? "")
        reposIdArray.append(detail.id)
    }
    
    private func clearAllArrays() {
        nameRepoArray.removeAll(keepingCapacity: false)
        languageArray.removeAll(keepingCapacity: false)
        descriptionArray.removeAll(keepingCapacity: false)
        reposIdArray.removeAll(keepingCapacity: false)
    }
    
    @objc
    func backToAuthView() {
        KeyValueStorage.shared.deleteAuthToken()
        KeyValueStorage.shared.deleteReposUrl()
        
        let authViewController = AuthenticationViewController(nibName: "AuthenticationViewController", bundle: nil)
        navigationController?.setViewControllers([authViewController], animated: false)
    }

}
