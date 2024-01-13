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
    
// MARK: - Setup/configure methods for view
    
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        setupButton()
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("ErrorView", owner: self)?.first as? UIView else { return UIView() }
        return view
    }
    
    private func setupButton() {
        retryButton.setButtonText(buttonText: "Retry")
        retryButtonAction()
    }
    
    public func setTypeOfPreviousView(type: ControllerType) {
        previousView = type
    }
    
// MARK: - Set properties to error view

    public func showErrorView() {
        switch previousView {

        case .authController:
            setupViewByError(imageName: "internetError",
                             titleText: "Connection Error",messageText: "Check your internet connection",
                             titleColor: .red, messageColor: .white)

        case .repoListBadConnection:
            setupViewByError(imageName: "internetError",
                             titleText: "Connection Error",messageText: "Check your internet connection",
                             titleColor: .red, messageColor: .white)

        case .repoListEmpty:
            setupViewByError(imageName: "emptyFolder",
                             titleText: "Empty",messageText: "No repositories at the moment",
                             titleColor: .cyan, messageColor: .white)

        case .repoDetailBadConnection:
            setupViewByError(imageName: "internetError",
                             titleText: "Connection Error",messageText: "Check your internet connection",
                             titleColor: .red, messageColor: .white)

        case .repoDetailReadmeError:
            setupViewByError(imageName: "internetError",
                             titleText: "Load error",messageText: "Check your internet connection",
                             titleColor: .red, messageColor: .white)

        case .other:
            setupViewByError(imageName: "otherError",
                             titleText: "Something gone wrong",messageText: "Reboot your app and check Internet",
                             titleColor: .red, messageColor: .white)
        }
    }
    
    public func hideErrorView() {
        isHidden = true
    }
    
    private func showElementsErrorView() {
        isHidden = false
    }
    
    private func setupViewByError(imageName: String, titleText: String, messageText: String, titleColor: UIColor, messageColor: UIColor) {
        showElementsErrorView()
        errorImage.image = UIImage(named: "\(imageName)")
        errorTitle.text = titleText
        errorMessage.text = messageText
        errorTitle.textColor = titleColor
        errorMessage.textColor = messageColor
    }
    
// MARK: - Methods to back previous view

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
                    self.delegate?.retryConnectToInternet()
                    self.retryButton.stopLoading()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: successWorkItem)

            } failureHandler: {
                let failureWorkItem = {
                    self.setupViewByError(imageName: "internetError",
                                          titleText: "Connection Error",messageText: "Check your internet connection",
                                          titleColor: .red,messageColor: .white)
                    self.showErrorView()
                    self.retryButton.stopLoading()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: failureWorkItem)
            }

            
        case .repoDetailReadmeError:
            InternetConnection.shared.checkInternetConnection {
                let successWorkItem = {
                    self.delegate?.retryConnectToInternet()
                    self.retryButton.stopLoading()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: successWorkItem)

            } failureHandler: {
                let failureWorkItem = {
                    self.setupViewByError(imageName: "internetError",
                                                      titleText: "Load error",messageText: "Check your internet connection",
                                                      titleColor: .red, messageColor: .white)
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
            InternetConnection.shared.checkInternetConnection {
                let successWorkItem = {
                    self.delegate?.retryConnectToInternet()
                    self.retryButton.stopLoading()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: successWorkItem)

            } failureHandler: {
                let failureWorkItem = {
                    self.setupViewByError(imageName: "otherError",
                                          titleText: "Something gone wrong",messageText: "Reboot your app and check Internet",
                                          titleColor: .red, messageColor: .white)
                    self.showErrorView()
                    self.retryButton.stopLoading()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: failureWorkItem)
            }
        }
    }
}
