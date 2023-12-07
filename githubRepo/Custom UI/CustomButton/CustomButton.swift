//
//  CustomButton.swift
//  githubRepo
//
//  Created by Vyacheslav on 07.12.2023.
//

import UIKit

class CustomButton: UIView {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("CustomButton", owner: self)?.first as? UIView else { return UIView() }
        loadingIndicator.isHidden = true
        signInButton.titleLabel?.text = "Sign In"
        return view
    }
    
    func startAnim() {
        signInButton.titleLabel?.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    @IBAction func tapButton(_ sender: Any) {
        startAnim()
    }
}
