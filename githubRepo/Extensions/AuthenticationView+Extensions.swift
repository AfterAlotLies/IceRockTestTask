//
//  AuthenticationView+Extensions.swift
//  githubRepo
//
//  Created by Vyacheslav on 06.12.2023.
//

import UIKit

//MARK: - AuthenticatinoViewController + ErrorViewDelegate
extension AuthenticationViewController: ErrorViewDelegate {
    
    func retryConnectToInternet() {
        updateViewBasedOnResponse(response: .success)
    }
}
