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
    
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), type: .circleStrokeSpin, color: .white)
    
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
        
        subview.addSubview(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: subview.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: subview.centerYAnchor)
        ])
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("CustomButtonUI", owner: self)?.first as? UIView else { return UIView() }
        
        return view
    }
    
    func setButtonText(buttonText: String) {
        customButton.titleLabel?.isHidden = false
        
        let font = UIFont(name: "SFProDisplay-Bold", size: 16)
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
    
    @IBAction func makeActionByClick(_ sender: Any) {
        actionHandler?()
    }
}
