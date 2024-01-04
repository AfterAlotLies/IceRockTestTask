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
    
    let internetConnection = InternetConnection.shared.internetConnection
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
        self.alpha = 1
        errorImage.isHidden = false
        errorTitle.isHidden = false
        errorMessage.isHidden = false
        retryButton.isHidden = false
    }
    
    private func retryButtonAction() {
        retryButton.actionHandler = {
            try? self.internetConnection.startNotifier()
            self.retryBackToAuthView()
        }
    }
    
    private func retryBackToAuthView() {
        if internetConnection.connection == .wifi || internetConnection.connection == .cellular {
            delegate?.retryAction()
        } else {
            internetConnection.stopNotifier()
            showErrorView()
        }
    }
}
