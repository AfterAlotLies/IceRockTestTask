//
//  LocalizedStrings.swift
//  githubRepo
//
//  Created by Vyacheslav on 13.01.2024.
//

import Foundation

public enum LocalizedStrings {
    static let titleAlert = NSLocalizedString("Alert.ErrorTittle.Error", comment: "")
    static let messageAlert = NSLocalizedString("Alert.ErrorMessage.Enter.Token", comment: "")
    
    static let buttonAuthController = NSLocalizedString("AuthController.CustomButton.TitleButton.SignIn", comment: "")
    static let buttonErrorView = NSLocalizedString("ErrorView.CustomButton.TitleButton.Retry", comment: "")
    
    static let noReadme = NSLocalizedString("RepoDetail.No.Readme", comment: "")
    static let emptyReadme = NSLocalizedString("RepoDetail.Readme.Empty", comment: "")
    
    static let licenseRepoDetail = NSLocalizedString("TopRepoDetail.License", comment: "")
    static let starsRepoDetail = NSLocalizedString("TopRepoDetail.Stars", comment: "")
    static let forksRepoDetail = NSLocalizedString("TopRepoDetail.Forks", comment: "")
    static let watchersRepoDetail = NSLocalizedString("TopRepoDetail.Watchers", comment: "")
    
    static let placeholderTokenField = NSLocalizedString("TokenInput.Placeholder", comment: "")
    
    static let badConnectionTitle = NSLocalizedString("ErrorView.BadConnection.Title.Connection.Error", comment: "")
    static let badConnectionMessage = NSLocalizedString("ErrorView.BadConnection.ReadmeError.Message.Check.Internet", comment: "")
    static let emptyRepositoryTitle = NSLocalizedString("ErrorView.EmptyRepo.Title.Empty", comment: "")
    static let emptyRepositoryMessage = NSLocalizedString("ErrorView.EmptyRepo.Message.No.Repo", comment: "")
    static let readmeErrorTitle = NSLocalizedString("ErrorView.ReadmeError.Title.Error", comment: "")
    static let otherErrorTitle = NSLocalizedString("ErrorView.OtherError.Title.Error", comment: "")
    static let otherErrorMessage = NSLocalizedString("ErrorView.OtherError.Message.Check.Internet", comment: "")
    
    static let repoListTitle = NSLocalizedString("RepoList.navTitle.Repositories", comment: "")
}
