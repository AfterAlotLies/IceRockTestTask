//
//  UIViewController+Extensions.swift
//  githubRepo
//
//  Created by Vyacheslav on 04.01.2024.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
    func retryAction()
    func retryToGetRepoList()
}

extension ErrorViewDelegate {
    func retryToGetRepoList() {
        //not necessary to use
    }
}
