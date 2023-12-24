//
//  RepositoryDetailInfoViewController.swift
//  githubRepo
//
//  Created by Vyacheslav on 01.12.2023.
//

import UIKit
import Down

class RepositoryDetailInfoViewController: UIViewController {
    
    @IBOutlet private weak var topRepoInfoView: RepositoryDetail!
    @IBOutlet private weak var readmeTextView: UITextView!
    
    private var chosenRepoId: String = ""
    
    var readmeString: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRepositoryDetail()
        
        AppRepository.shared.getRepositoryReadme(ownerName: "", repositoryName: "", branchName: "") { repoReadme, error in
            if error != nil {
                print("bad(")
            } else {
                guard let repoInfo = repoReadme else { return }
                DispatchQueue.main.async {
                    self.renderMarkdown(markdown: repoInfo)
                }
            }
        }
    }
    
    func renderMarkdown(markdown: String) {
        do {
            let downView = try DownView(frame: self.readmeTextView.bounds, markdownString: markdown)
            downView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.readmeTextView.addSubview(downView)
        } catch {
            print("Error rendering Markdown: \(error.localizedDescription)")
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
