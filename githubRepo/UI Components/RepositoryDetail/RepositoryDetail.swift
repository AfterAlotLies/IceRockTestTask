//
//  CustomViewForRepoInfo.swift
//  githubRepo
//
//  Created by Vyacheslav on 07.12.2023.
//

import UIKit

// MARK: - RepositoryDetail
class RepositoryDetail: UIView {
    
    @IBOutlet private weak var githubUrlLabel: UILabel!
    @IBOutlet private weak var licenseLabel: UILabel!
    @IBOutlet private weak var nameLicenseLabel: UILabel!
    @IBOutlet private weak var stackview: UIStackView!
    @IBOutlet private weak var starsView: BottomViewRepositoryDetail!
    @IBOutlet private weak var forksView: BottomViewRepositoryDetail!
    @IBOutlet private weak var watchersView: BottomViewRepositoryDetail!
    
    private let starsColor: UIColor = UIColor(red: 250.0 / 255.0, green: 216.0 / 255.0, blue: 118.0 / 255.0, alpha: 1)
    private let forksColor: UIColor = UIColor(red: 109.0 / 255.0, green: 210.0 / 255.0, blue: 111.0 / 255.0, alpha: 1)
    private let watchersColor: UIColor = UIColor(red: 156.0 / 255.0, green: 253.0 / 255.0, blue: 249.0 / 255.0, alpha: 1)
    
    private var urlToOpen: String = ""
    
    // MARK: - Constants
    private enum Constants {
        static let repoDetailUI = "RepositoryDetailUI"
        static let starsImage = "starsImage"
        static let forksImage = "forksImage"
        static let watchersImage = "watchersImage"
        static let removingString = "https://"
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
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed(Constants.repoDetailUI, owner: self)?.first as? UIView else { return UIView() }
        return view
    }
    
    // MARK: - Public funcs
    func setupBottomView(stars: Int, forks: Int, watchers: Int) {
        starsView.setupBottomView(imageName: Constants.starsImage, count: stars, title: LocalizedStrings.starsRepoDetail, color: starsColor)
        forksView.setupBottomView(imageName: Constants.forksImage, count: forks, title: LocalizedStrings.forksRepoDetail, color: forksColor)
        watchersView.setupBottomView(imageName: Constants.watchersImage, count: watchers, title: LocalizedStrings.watchersRepoDetail, color: watchersColor)
    }
    
    func setTopRepositoryDetail(url: String, license: String, licenseName: String) {
        urlToOpen = url
        makeTapOnLink(url: url)
        licenseLabel.text = license
        nameLicenseLabel.text = licenseName
        setupFontToLabels()
    }
    
    func hideLicenseView() {
        stackview.arrangedSubviews[1].isHidden = true
    }
    
    // MARK: - Private funcs
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        let openLink = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap))
        githubUrlLabel.addGestureRecognizer(openLink)
    }
    
    private func makeTapOnLink(url: String) {
        let attributedGithubLabel = NSMutableAttributedString(string: url.replacingOccurrences(of: Constants.removingString, with: ""))
        let range = (attributedGithubLabel.string as NSString).range(of: url)
        attributedGithubLabel.addAttribute(.link, value: url, range: range)
        
        githubUrlLabel.attributedText = attributedGithubLabel
        githubUrlLabel.isUserInteractionEnabled = true
    }
    
    private func setupFontToLabels() {
        githubUrlLabel.font = FontSettings.SFProTextMedium16
        licenseLabel.font = FontSettings.SFProTextMedium16
        nameLicenseLabel.font = FontSettings.SFProTextMedium16
    }
    
    @objc
    private func handleLinkTap() {
        if let url = URL(string: urlToOpen) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
