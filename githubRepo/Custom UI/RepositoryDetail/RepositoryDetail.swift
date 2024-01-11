//
//  CustomViewForRepoInfo.swift
//  githubRepo
//
//  Created by Vyacheslav on 07.12.2023.
//

import UIKit

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
        guard let view = Bundle.main.loadNibNamed("RepositoryDetailUI", owner: self)?.first as? UIView else { return UIView() }

        return view
    }
    
    func setupBottomView(stars: Int, forks: Int, watchers: Int) {
        starsView.setupBottomView(imageName: "starsImage", count: stars, title: "stars", color: starsColor)
        forksView.setupBottomView(imageName: "forksImage", count: forks, title: "forks", color: forksColor)
        watchersView.setupBottomView(imageName: "watchersImage", count: watchers, title: "watchers", color: watchersColor)
    }
    
    func setTopRepositoryDetail(url: String, license: String, licenseName: String) {
        githubUrlLabel.text = url
        licenseLabel.text = license
        nameLicenseLabel.text = licenseName
    }
    
    func hideLicenseView() {
        stackview.arrangedSubviews[1].isHidden = true
    }
}
