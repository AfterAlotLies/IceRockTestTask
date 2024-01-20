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
    
    private enum Constants {
        static let repositoriesListUI = "RepositoriesListCellsUI"
        static let authController = "AuthenticationViewController"
        static let logoutImage = "logoutImage"
        static let repoListController = "RepositoryDetailInfoViewController"
    }
    
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 37, height: 37), type: .circleStrokeSpin, color: .white)
    
    private var nameRepoArray = [String]()
    private var languageArray = [String]()
    private var descriptionArray = [String]()
    private var branchArray = [String]()
    private var ownerNameArray = [String]()
    private var reposIdArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationRightItem()
        setupNavBar()
        setupView()
        setupLoaderIndicator()
        checkInternetConnection()
    }
    
// MARK: - Update view by response
    func updateViewBasedOnResponse(response: ResponseViewStatus) {
        switch response {
            
        case .success:
            
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
    
    func retryToGetRepositories() {
        checkInternetConnection()
    }
    
// MARK: - Check internet connection
    private func checkInternetConnection() {
        InternetConnectionManager.shared.checkInternetConnection {
            self.updateViewBasedOnResponse(response: .success)
        } failureHandler: {
            self.errorView.setTypeOfPreviousView(type: .repoListBadConnection)
            self.updateViewBasedOnResponse(response: .fail)
        }
    }
    
// MARK: - Request to get list of repositories
    private func getUserRepositories() {
        clearAllArrays()
        
        if loadingIndicator.isHidden == true {
            loadingIndicator.isHidden = false
        }
        
        loadingIndicator.startAnimating()
        AppRepository.shared.getRepositories { [weak self] repoDetail, error in
            guard let self = self else { return }
            if error != nil {
                DispatchQueue.main.async {
                    self.errorView.setTypeOfPreviousView(type: .other)
                    self.updateViewBasedOnResponse(response: .fail)
                }
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
                    } else {
                        self.errorView.setTypeOfPreviousView(type: .repoListEmpty)
                        self.updateViewBasedOnResponse(response: .fail)
                    }
                }
            }
        }
    }
    
// MARK: - Actions with arrays
    private func addInfoToArrays(detail: Repo) {
        nameRepoArray.append(detail.name)
        languageArray.append(detail.language ?? "")
        descriptionArray.append(detail.description ?? "")
        reposIdArray.append(detail.id)
        ownerNameArray.append(detail.owner.login)
        branchArray.append(detail.branch)
    }
    
    private func clearAllArrays() {
        nameRepoArray.removeAll(keepingCapacity: false)
        languageArray.removeAll(keepingCapacity: false)
        descriptionArray.removeAll(keepingCapacity: false)
        reposIdArray.removeAll(keepingCapacity: false)
    }
    
    @objc
    private func backToAuthView() {
        KeyValueStorage.shared.deleteAuthToken()
        KeyValueStorage.shared.deleteReposUrl()
        
        let authViewController = AuthenticationViewController(nibName: Constants.authController, bundle: nil)
        navigationController?.setViewControllers([authViewController], animated: false)
    }
}

// MARK: - RepositoriesListViewController + UITableViewDataSource
extension RepositoriesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameRepoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.repositoriesListUI) as! RepositoriesListCells
        cell.setFontToLabels()
        cell.setRepoName(repoName: nameRepoArray[indexPath.row])
        cell.setLanguage(language: languageArray[indexPath.row])
        cell.selectionStyle = .none
        if descriptionArray[indexPath.row] == "" {
            cell.hideDescriptionLabel()
        } else {
            cell.setDescriptionRepo(description: descriptionArray[indexPath.row])
        }
        return cell
    }
}

// MARK: - RepositoriesListViewController + UITableViewDelegate
extension RepositoriesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryDetail = RepositoryDetailInfoViewController(nibName: Constants.repoListController, bundle: nil)
        repositoryDetail.setChosenRepoId(repoId: reposIdArray[indexPath.row], branch: branchArray[indexPath.row],
                                         repoName: nameRepoArray[indexPath.row], owner: ownerNameArray[indexPath.row])
        repositoryDetail.navigationItem.title = nameRepoArray[indexPath.row]
        navigationController?.pushViewController(repositoryDetail, animated: true)
    }
}

// MARK: - Setup methods
private extension RepositoriesListViewController {
    
    private func setupNavBar() {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        navigationItem.backBarButtonItem?.title = ""
        title = LocalizedStrings.repoListTitle
    }
    
    private func setupNavigationRightItem() {
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
    
    private func setupView() {
        repoList.dataSource = self
        repoList.delegate = self
        errorView.delegate = self
        repoList.register(UINib(nibName: Constants.repositoriesListUI, bundle: nil), forCellReuseIdentifier: Constants.repositoriesListUI)
        repoList.separatorInset = UIEdgeInsets.zero
        loadingIndicator.isHidden = false
        navigationItem.backButtonTitle = ""
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
}
