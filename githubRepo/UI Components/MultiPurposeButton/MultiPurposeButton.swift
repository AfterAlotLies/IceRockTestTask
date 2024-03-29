//
//  CustomButtonClass.swift
//  githubRepo
//
//  Created by Vyacheslav on 07.12.2023.
//

import UIKit
import NVActivityIndicatorView

// MARK: - MultiPurposeButton
class MultiPurposeButton: UIView {
    
    @IBOutlet private weak var customButton: UIButton!
    
    // MARK: - Constants
    private enum Constants {
        static let multiPurposeButtonUI = "MultiPurposeButtonUI"
        static let loadingIndicatorFrame: CGRect = CGRect(x: 0, y: 0, width: 20, height: 20)
    }
    
    private let loadingIndicator = NVActivityIndicatorView(frame: Constants.loadingIndicatorFrame, type: .circleStrokeSpin, color: .white)
    
    private var clickButtonAction: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed(Constants.multiPurposeButtonUI, owner: self)?.first as? UIView else { return UIView() }
        
        return view
    }
    
    // MARK: - Public funcs
    func setActionOnButton(_ actionHandler: (() -> Void)?) {
        clickButtonAction = actionHandler
    }
    
    func setButtonText(buttonText: String) {
        customButton.titleLabel?.isHidden = false
        
        let font = FontSettings.SFProDisplayBold16
        let attributes = [NSAttributedString.Key.font: font]
        let attributedQuote = NSAttributedString(string: buttonText, attributes: attributes as [NSAttributedString.Key : Any])
        
        customButton.setAttributedTitle(attributedQuote, for: .normal)
        customButton.tintColor = .white
        loadingIndicator.isHidden = true
    }
    
    func startLoading() {
        customButton.titleLabel?.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        customButton.titleLabel?.isHidden = false
    }
    
    // MARK: - IBAction
    @IBAction func makeActionByClick(_ sender: Any) {
        clickButtonAction?()
    }
    
    // MARK: - Private funcs
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        
        subview.addSubview(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: subview.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: subview.centerYAnchor)
        ])
    }
}
