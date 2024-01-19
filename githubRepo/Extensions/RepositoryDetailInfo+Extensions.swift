//
//  RepositoryDetailInfo+Extensions.swift
//  githubRepo
//
//  Created by Vyacheslav on 05.01.2024.
//

import UIKit

// MARK: - RepositoryDetailInfoViewController + ErrorViewDelegate
extension RepositoryDetailInfoViewController: ErrorViewDelegate {
    
    func retryConnectToInternet() {
        updateViewBasedOnResponse(response: .success)
    }
}
