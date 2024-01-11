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
    @IBOutlet private weak var retryButton: CustomButtonClass!
    
    private var previousView : ControllerType = .other
    weak var delegate: ErrorViewDelegate?
    
    public enum ControllerType : String {
        case authController = "authController"
        case repoListBadConnection = "repoListBadConnection"
        case repoListEmpty = "repoListEmpty"
        case repoDetailBadConnection = "repoDetailBadConnection"
        case repoDetailReadmeError = "repoDetailReadmeError"
        case other = "other"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        setupButton()
    }
    
    func setTypeOfPreviousView(type: ControllerType) {
        previousView = type
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("ErrorView", owner: self)?.first as? UIView else { return UIView() }
        return view
    }
    
    private func setupButton() {
        retryButton.setButtonText(buttonText: "Retry")
        retryButtonAction()
    }
    
    public func hideErrorView() {
        self.alpha = 0
        errorImage.isHidden = true
        errorTitle.isHidden = true
        errorMessage.isHidden = true
        retryButton.isHidden = true
    }
    
    public func showErrorView() {
        switch previousView {

        case .authController:
            badInternetConnectionError()

        case .repoListBadConnection:
            badInternetConnectionError()

        case .repoListEmpty:
            emptyRepositoriesWarning()

        case .repoDetailBadConnection:
            badInternetConnectionError()

        case .repoDetailReadmeError:
            loadReadmeError()

        case .other:
            otherErrors()
        }
    }
    
    private func showElementsErrorView() {
        self.alpha = 1
        errorImage.isHidden = false
        errorTitle.isHidden = false
        errorMessage.isHidden = false
        retryButton.isHidden = false
    }
    
    private func badInternetConnectionError() {
        showElementsErrorView()
        errorImage.image = UIImage(named: "internetError")
        errorTitle.text = "Connection error"
        errorMessage.text = "Check your internet connection"
        errorTitle.textColor = .red
        errorMessage.textColor = .white

    }
    
    private func emptyRepositoriesWarning() {
        showElementsErrorView()
        errorImage.image = UIImage(named: "emptyFolder")
        errorTitle.text = "Empty"
        errorMessage.text = "No repositories at the moment"
        errorTitle.textColor = .cyan
        errorMessage.textColor = .white
    }
    
    private func loadReadmeError() {
        showElementsErrorView()
        errorImage.image = UIImage(named: "internetError")
        errorTitle.text = "Load error"
        errorMessage.text = "Check your internet connection"
        errorTitle.textColor = .red
        errorMessage.textColor = .white
    }
    
    private func otherErrors() {
        showElementsErrorView()
        errorImage.image = UIImage(named: "otherError")
        errorTitle.text = "Something gone wrong"
        errorMessage.text = "Reboot your app and check Internet"
        errorTitle.textColor = .red
        errorMessage.textColor = .white
    }
    
    private func retryButtonAction() {
        retryButton.actionHandler = {
            self.retryButton.startLoading()
            self.retryBackToAuthView(previousView: self.previousView)
        }
    }
    
    private func retryBackToAuthView(previousView: ControllerType) {
        switch previousView {

            
        case .authController, .repoListBadConnection, .repoDetailBadConnection:
            InternetConnection.shared.checkInternetConnection {
                let successWorkItem = {
                    self.delegate?.retryAction()
                    self.retryButton.stopLoading()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: successWorkItem)
            } failureHandler: {
                let failureWorkItem = {
                    self.badInternetConnectionError()
                    self.showErrorView()
                    self.retryButton.stopLoading()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: failureWorkItem)
            }

            
        case .repoDetailReadmeError:
            InternetConnection.shared.checkInternetConnection {
                let successWorkItem = {
                    self.delegate?.retryAction()
                    self.retryButton.stopLoading()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: successWorkItem)
            } failureHandler: {
                let failureWorkItem = {
                    self.loadReadmeError()
                    self.showErrorView()
                    self.retryButton.stopLoading()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: failureWorkItem)
            }

            
        case .repoListEmpty:
            let workItem = {
                self.delegate?.retryToGetRepoList()
                self.retryButton.stopLoading()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: workItem)

            
        default:
            print("other")
        }
    }
}
