//
//  RepositoryDetailInfoViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 01.12.2023.
//

import UIKit
import MarkdownKit
import SwiftyMarkdown

class RepositoryDetailInfoViewController: UIViewController {
    
    @IBOutlet private weak var topRepoInfoView: RepositoryDetail!
    @IBOutlet private weak var readmeTextView: UITextView!
    @IBOutlet private weak var readmeLoader: UIActivityIndicatorView!
    @IBOutlet private weak var errorView: ErrorView!
    
    private var chosenRepoId: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        getRepositoryDetail()
        //readmeLoader.startAnimating()
        readmeLoader.isHidden = true
        AppRepository.shared.getRepositoryReadme(ownerName: "", repositoryName: "", branchName: "") { repoReadme, error in
            if error != nil {
                print("bad(")
            } else {
                guard let repoInfo = repoReadme else { return }
                let changedRepoInfo = repoInfo.replacingOccurrences(of: "```", with: "`")
                let markdownText = SwiftyMarkdown(string: changedRepoInfo)
                self.readmeTextView.attributedText = markdownText.attributedString()
                self.readmeTextView.textColor = .white
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func getRepositoryDetail() {
        AppRepository.shared.getRepository(repoId: chosenRepoId) { response, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            } else {
                guard let repoDetail = response else { return }
                self.setInRepoDetail(repoDetail: repoDetail)
            }
            self.topRepoInfoView.hideLicenseView()
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
