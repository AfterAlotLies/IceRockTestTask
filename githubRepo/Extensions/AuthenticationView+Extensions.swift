//
//  AuthenticationView+Extensions.swift
//  githubRepo
//
//  Created by Vyacheslav on 06.12.2023.
//

import UIKit

extension AuthenticationViewController {
    
    func hideKeyBoard() {
        let hideKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardTap)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - AuthenticatinoViewController + ErrorViewDelegate
extension AuthenticationViewController: ErrorViewDelegate {
    
    func retryAction() {
        updateViewBasedOnResponse(response: "success")
    }
}
