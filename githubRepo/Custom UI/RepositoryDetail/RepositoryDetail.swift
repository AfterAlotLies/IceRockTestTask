//
//  CustomViewForRepoInfo.swift
//  githubRepo
//
//  Created by Vyacheslav on 07.12.2023.
//

import UIKit

class RepositoryDetail: UIView {
    
    @IBOutlet weak var githubUrlLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var nameLicenseLabel: UILabel!
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var starsView: BottomViewRepositoryDetail!
    @IBOutlet weak var forksView: BottomViewRepositoryDetail!
    @IBOutlet weak var watchersView: BottomViewRepositoryDetail!
    
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
    
    func hideLicenseView() {
        stackview.arrangedSubviews[1].isHidden = true
    }
}
