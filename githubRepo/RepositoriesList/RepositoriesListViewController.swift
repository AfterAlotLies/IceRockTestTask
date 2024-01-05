//
//  RepositoriesListViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 29.11.2023.
//

import UIKit
import Reachability

class RepositoriesListViewController: UIViewController {

    @IBOutlet private weak var repoList: UITableView!
    @IBOutlet private weak var loadingTableView: UIActivityIndicatorView!
    @IBOutlet private weak var errorView: ErrorView!
    
    var nameRepoArray = [String]()
    var languageArray = [String]()
    var descriptionArray = [String]()
    var reposIdArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationRightItem()
        setupNavBar()
        setupView()
        checkInternetConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func showOrHideBadConnectionRepoListView(response: String) {
        switch response {
            
        case "success":
            
            repoList.isHidden = false
            loadingTableView.isHidden = false
            errorView.hideErrorView()
            getUserRepositories()
            
        default:
            repoList.isHidden = true
            loadingTableView.isHidden = true
            errorView.showErrorView()
        }
    }
    
    public func retryToGetRepositories() {
        checkInternetConnection()
    }
    
    private func checkInternetConnection() {
        InternetConnection.shared.checkInternetConnection {
            self.showOrHideBadConnectionRepoListView(response: "success")
        } failureHandler: {
            self.errorView.setTypeOfPreviousView(type: .repoListBadConnection)
            self.showOrHideBadConnectionRepoListView(response: "fail")
        }
    }
    
    private func getUserRepositories() {
        clearAllArrays()
        
        if loadingTableView.isHidden == true {
            loadingTableView.isHidden = false
        }
        
        loadingTableView.startAnimating()
        AppRepository.shared.getRepositories { repoDetail, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
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
                        self.loadingTableView.stopAnimating()
                        self.loadingTableView.isHidden = true
                    } else {
                        self.errorView.setTypeOfPreviousView(type: .repoListEmpty)
                        self.showOrHideBadConnectionRepoListView(response: "empty")
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
        loadingTableView.isHidden = false
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
