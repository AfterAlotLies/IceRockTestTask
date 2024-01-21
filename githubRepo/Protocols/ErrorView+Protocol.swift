//
//  UIViewController+Extensions.swift
//  githubRepo
//
//  Created by Vyacheslav on 04.01.2024.
//

import UIKit

// MARK: - ErrorViewDelegate
protocol ErrorViewDelegate: AnyObject {
    
    func retryConnectToInternet()
    func retryToGetRepoList()
}

// MARK: - ErrorViewDelegate + retryToGetRepoList
extension ErrorViewDelegate {
    
    func retryToGetRepoList() {
        // using for repeating to request get list repositories
    }
}
