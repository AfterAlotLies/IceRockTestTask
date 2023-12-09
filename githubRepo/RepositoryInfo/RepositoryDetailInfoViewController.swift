//
//  RepositoryDetailInfoViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 01.12.2023.
//

import UIKit

class RepositoryDetailInfoViewController: UIViewController {

    @IBOutlet private weak var topRepoInfoView: RepositoryDetail!

    private var chosenRepoId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRepositoryDetail()
    }
    
    private func getRepositoryDetail() {
        AppRepository.shared.getRepository(repoId: chosenRepoId) { response, error in
            if error != nil {
                print("smth bad there")
            } else {
                guard let repoDetail = response else { return }
                self.setInRepoDetail(repoDetail: repoDetail)
            }
            //self.topRepoInfoView.hideLicenseView()
        }
    }
    
    private func setInRepoDetail(repoDetail: RepoDetails) {
        topRepoInfoView.githubUrlLabel.text = repoDetail.githubUrlRepo
        topRepoInfoView.starsCountLabel.text = repoDetail.stargazers.intToString()
        topRepoInfoView.forksCountLabel.text = repoDetail.forks.intToString()
        topRepoInfoView.watchersCoutnLabel.text = repoDetail.watchers.intToString()
    }
    
    func setChosenRepoId(repoId: Int?) {
        guard let repoId = repoId else { return }
        chosenRepoId = repoId.intToString()
    }
}
