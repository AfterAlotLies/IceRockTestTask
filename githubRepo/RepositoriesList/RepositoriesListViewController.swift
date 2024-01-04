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
    
    private let internetConnection = InternetConnection.shared.internetConnection

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
        print("did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will appear")
    }
    
    public func showBadConnectionView(response: String) {
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
        if internetConnection.connection == .wifi || internetConnection.connection == .cellular {
            errorView.hideErrorView()
            getUserRepositories()
        } else {
            errorView.setTypeOfPreviousView(type: .repoListBadConnection)
            showBadConnectionView(response: "fail")
        }
    }
    
    private func getUserRepositories() {
        clearAllArrays()
        if loadingTableView.isHidden == true {
            loadingTableView.isHidden = false
        }
        loadingTableView.startAnimating()
        AppRepository.shared.getRepositories { data, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            } else {
                guard let repositoriesInfo = data else { return }
                for info in repositoriesInfo {
                    self.addInfoToArrays(info: info)
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
                        self.showBadConnectionView(response: "empty")
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
    
    private func addInfoToArrays(info: Repo) {
        nameRepoArray.append(info.name)
        languageArray.append(info.language ?? "")
        descriptionArray.append(info.description ?? "")
        reposIdArray.append(info.id)
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
