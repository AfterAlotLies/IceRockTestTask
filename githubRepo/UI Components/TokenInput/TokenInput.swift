//
//  TokenInputClass.swift
//  githubRepo
//
//  Created by Vyacheslav on 24.12.2023.
//

import UIKit

// MARK: - TokenInput
class TokenInput: UIView {
    
    @IBOutlet private weak var tokenInputField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Constants
    private enum Constants {
        static let tokenInputUI = "TokenInputUI"
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
    
    // MARK: - Public funcs
    func clearTextField() {
        tokenInputField.text = ""
    }
    
    func checkCorrectToken() -> String {
        guard let token = tokenInputField.text else {
            return ""
        }
        return token
    }
    
    func displayErrorText() {
        UIView.animate(withDuration: 0.5) {
            self.errorLabel.alpha = 1.0
            self.tokenInputField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    // MARK: - Private funcs
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        configureField()
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed(Constants.tokenInputUI, owner: self)?.first as? UIView else { return UIView() }
        return view
    }
    
    private func configureField() {
        tokenInputField.leftViewMode = .always
        tokenInputField.layer.borderColor = UIColor.darkGray.cgColor
        tokenInputField.attributedPlaceholder = NSAttributedString(string: LocalizedStrings.placeholderTokenField,
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tokenInputField.backgroundColor = .clear
        errorLabel.alpha = 0
        tokenInputField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tokenInputField.addTarget(self, action: #selector(touchUpInsideTextField), for: .editingDidEnd)
        
        tokenInputField.font = FontSettings.SFProDisplayMedium16
        errorLabel.font = FontSettings.SFProDispalyMedium12
    }
    
    // MARK: - Actions with TextField
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.errorLabel.alpha = 0
            self.tokenInputField.layer.borderColor = UIColor.systemCyan.cgColor
        }
    }
    
    @objc
    private func touchUpInsideTextField() {
        tokenInputField.layer.borderColor = UIColor.systemCyan.cgColor
    }
}
