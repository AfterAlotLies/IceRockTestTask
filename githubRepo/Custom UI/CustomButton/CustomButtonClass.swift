//
//  CustomButtonClass.swift
//  githubRepo
//
//  Created by Vyacheslav on 07.12.2023.
//

import UIKit
import NVActivityIndicatorView

class CustomButtonClass: UIView {
    
    @IBOutlet private weak var customButton: UIButton!
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
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("CustomButtonUI", owner: self)?.first as? UIView else { return UIView() }

        return view
    }
    
    func setButtonText(buttonText: String) {
        customButton.titleLabel?.isHidden = false
        customButton.titleLabel?.font = UIFont(name: "SF Mono", size: 20)
        customButton.setTitle(buttonText, for: .normal)
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
    
    @IBAction func makeActionByClick(_ sender: Any) {
        actionHandler?()
    }
}
