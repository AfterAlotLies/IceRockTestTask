//
//  TokenInputClass.swift
//  githubRepo
//
//  Created by Vyacheslav on 24.12.2023.
//

import UIKit

class TokenInput: UIView, UITextFieldDelegate {
    
    @IBOutlet private weak var tokenInputField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private enum Constants {
        static let tokenInputUI = "TokenInputUI"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
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
        
        tokenInputField.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        errorLabel.font = UIFont(name: "SFProDisplay-Medium", size: 12)
    }
    
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
