//
//  RepositoryDetailInfo+Extensions.swift
//  githubRepo
//
//  Created by Vyacheslav on 05.01.2024.
//

import UIKit

extension RepositoryDetailInfoViewController: ErrorViewDelegate {
    
    func retryAction() {
        updateViewBasedOnResponse(response: "success")
    }
    
// MARK: - Setup Detail View
    func setupNavigationRightItem() {
        let barButton = UIButton()

        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.setImage(UIImage(named: "logoutImage"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        
        backButton.addTarget(self,
                             action: #selector(backToAuthView),
                             for: .touchUpInside)

        barButton.addSubview(backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
    }
}
