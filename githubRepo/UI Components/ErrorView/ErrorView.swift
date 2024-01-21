//
//  ErrorView.swift
//  githubRepo
//
//  Created by Vyacheslav on 03.01.2024.
//

import UIKit
import Reachability

class ErrorView: UIView {
    
    @IBOutlet private weak var errorImage: UIImageView!
    @IBOutlet private weak var errorTitle: UILabel!
    @IBOutlet private weak var errorMessage: UILabel!
    @IBOutlet private weak var retryButton: MultiPurposeButton!
    
    private var previousView : ControllerType = .other
    weak var delegate: ErrorViewDelegate?
    
    // MARK: - Constants
    private enum Constants {
        static let errorView = "ErrorView"
        static let internetError = "internetError"
        static let emptyFolder = "emptyFolder"
        static let otherError = "otherError"
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed(Constants.errorView, owner: self)?.first as? UIView else { return UIView() }
        return view
    }
    
    // MARK: - Setup/configure methods for view
    func setTypeOfPreviousView(type: ControllerType) {
        previousView = type
    }
    
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        setupButton()
    }
    
    private func setupButton() {
        retryButton.setButtonText(buttonText: LocalizedStrings.buttonErrorView)
        retryButtonAction()
    }
    
    private func setupButtonForEmptyError() {
        retryButton.setButtonText(buttonText: LocalizedStrings.buttonErrorViewEmptyError)
        retryButtonAction()
    }
    
    // MARK: - Set properties to error view
    func showErrorView() {
        switch previousView {
        case .authController, .repoDetailBadConnection, .repoListBadConnection:
            setupViewByError(imageName: Constants.internetError,
                             titleText: LocalizedStrings.badConnectionTitle,
                             messageText: LocalizedStrings.badConnectionMessage,
                             titleColor: .red, messageColor: .white)
            
        case .repoListEmpty:
            setupViewByError(imageName: Constants.emptyFolder,
                             titleText: LocalizedStrings.emptyRepositoryTitle ,
                             messageText: LocalizedStrings.emptyRepositoryMessage,
                             titleColor: .cyan, messageColor: .white)
            setupButtonForEmptyError()
            
        case .repoDetailReadmeError:
            setupViewByError(imageName: Constants.internetError,
                             titleText: LocalizedStrings.readmeErrorTitle,
                             messageText: LocalizedStrings.badConnectionMessage,
                             titleColor: .red, messageColor: .white)
            
        case .other:
            setupViewByError(imageName: Constants.otherError,
                             titleText: LocalizedStrings.otherErrorTitle,
                             messageText: LocalizedStrings.otherErrorMessage,
                             titleColor: .red, messageColor: .white)
        }
    }
    
    func setErrorViewHidden(_ isHidden: Bool) {
        self.isHidden = isHidden
    }
    
    private func setupViewByError(imageName: String,
                                  titleText: String,
                                  messageText: String,
                                  titleColor: UIColor,
                                  messageColor: UIColor) {
        setErrorViewHidden(false)
        errorImage.image = UIImage(named: "\(imageName)")
        errorTitle.text = titleText
        errorMessage.text = messageText
        errorTitle.textColor = titleColor
        errorMessage.textColor = messageColor
    }
    
    private func setupFontToLabels() {
        errorTitle.font = FontSettings.SFProTextMedium16
        errorMessage.font = FontSettings.SFProTextMedium12
    }
    
    // MARK: - Methods to back previous view
    private func retryButtonAction() {
        retryButton.setActionOnButton { [weak self] in
            guard let self = self else { return }
            self.retryButton.startLoading()
            self.retryBackToPreviousView(previousView: self.previousView)
        }
    }
    
    private func retryBackToPreviousView(previousView: ControllerType) {
        switch previousView {
        case .authController, .repoListBadConnection, .repoDetailBadConnection:
            retryOnBadConnection()
        case .repoDetailReadmeError:
            retryOnReadmeError()
        case .repoListEmpty:
            retryOnEmptyList()
        default:
            retryOnOtherErrors()
        }
    }
    
    // Retry to repair an error "Bad connection"
    private func retryOnBadConnection() {
        InternetConnectionManager.shared.checkInternetConnection {
            let successWorkItem = {
                self.delegate?.retryConnectToInternet()
                self.retryButton.stopLoading()
            }
            self.startWorkItem(successWorkItem)
            
        } failureHandler: {
            let failureWorkItem = {
                self.setupViewByError(imageName: Constants.internetError,
                                      titleText: LocalizedStrings.badConnectionTitle, messageText: LocalizedStrings.badConnectionMessage,
                                      titleColor: .red,messageColor: .white)
                self.showErrorView()
                self.retryButton.stopLoading()
            }
            self.startWorkItem(failureWorkItem)
        }
    }
    
    // Retry to repair an error "Load error" in readme
    private func retryOnReadmeError() {
        InternetConnectionManager.shared.checkInternetConnection {
            let successWorkItem = {
                self.delegate?.retryConnectToInternet()
                self.retryButton.stopLoading()
            }
            self.startWorkItem(successWorkItem)
            
        } failureHandler: {
            let failureWorkItem = {
                self.setupViewByError(imageName: Constants.internetError,
                                      titleText: LocalizedStrings.readmeErrorTitle, messageText: LocalizedStrings.badConnectionMessage,
                                      titleColor: .red, messageColor: .white)
                self.showErrorView()
                self.retryButton.stopLoading()
            }
            self.startWorkItem(failureWorkItem)
        }
    }
    
    // Retry to repair an error "Empty"
    private func retryOnEmptyList() {
        let workItem = {
            self.delegate?.retryToGetRepoList()
            self.retryButton.stopLoading()
        }
        self.startWorkItem(workItem)
    }
    
    // Retry to repair other errors
    private func retryOnOtherErrors() {
        InternetConnectionManager.shared.checkInternetConnection {
            let successWorkItem = {
                self.delegate?.retryConnectToInternet()
                self.retryButton.stopLoading()
            }
            self.startWorkItem(successWorkItem)
        } failureHandler: {
            let failureWorkItem = {
                self.setupViewByError(imageName: Constants.otherError,
                                      titleText: LocalizedStrings.otherErrorTitle, messageText: LocalizedStrings.otherErrorMessage,
                                      titleColor: .red, messageColor: .white)
                self.showErrorView()
                self.retryButton.stopLoading()
            }
            self.startWorkItem(failureWorkItem)
        }
    }
}

// MARK: - ErrorView + Private work item
private extension ErrorView {
    
    func startWorkItem(_ workItem: @escaping (() -> ())) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: workItem)
    }
}
