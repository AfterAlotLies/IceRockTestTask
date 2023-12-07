//
//  CustomButtonClass.swift
//  githubRepo
//
//  Created by Vyacheslav on 07.12.2023.
//

import UIKit

class CustomButtonClass: UIView {
    
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    var actionHandler: (() -> Void)?
    
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
        setupButtonUI()
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("CustomButtonUI", owner: self)?.first as? UIView else { return UIView() }

        return view
    }
    
    private func setupButtonUI() {
        signUpButton.titleLabel?.text = "Sign In"
        loadingIndicator.isHidden = true
    }
    
    func startLoading() {
        signUpButton.titleLabel?.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        signUpButton.titleLabel?.isHidden = false
    }
    
    @IBAction func signInUser(_ sender: Any) {
        actionHandler?()
    }
}
