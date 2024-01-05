//
//  RepositoryDetailInfo+Extensions.swift
//  githubRepo
//
//  Created by Vyacheslav on 05.01.2024.
//

import UIKit

extension RepositoryDetailInfoViewController: ErrorViewDelegate {
    
    func retryAction() {
        showOrHideBadConnectionRepoDetailView(response: "success")
    }
}
