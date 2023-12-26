//
//  RepositoriesListViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 29.11.2023.
//

import UIKit

class RepositoriesListViewController: UIViewController {

    @IBOutlet private weak var repoList: UITableView!
    @IBOutlet private weak var loadingTableView: UIActivityIndicatorView!
    
    var nameRepoArray = [String]()
    var languageArray = [String]()
    var descriptionArray = [String]()
    var reposIdArray = [Int]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationRightItem()
        setupNavBar()
        setupView()
        //спросить здесь ли метод должен быть или нет а то он утечку памяти ловит в аппиаре
        getUserRepositories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backButtonTitle = ""
    }
    
    private func getUserRepositories() {
        clearAllArrays()
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
                    self.repoList.reloadData()
                    self.loadingTableView.stopAnimating()
                    self.loadingTableView.isHidden = true
                }
            }
        }
    }
    
    private func setupView() {
        repoList.dataSource = self
        repoList.delegate = self
        repoList.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        repoList.separatorInset = UIEdgeInsets.zero
        loadingTableView.isHidden = false
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
