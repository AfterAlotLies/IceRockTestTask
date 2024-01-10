//
//  bottomViewRepositoryDetail.swift
//  githubRepo
//
//  Created by Vyacheslav on 09.01.2024.
//

import UIKit

class BottomViewRepositoryDetail: UIView {
    
    @IBOutlet private weak var imageDetail: UIImageView!
    @IBOutlet private weak var numsLabelDetail: UILabel!
    @IBOutlet private weak var nameLabelDetail: UILabel!
    
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
        guard let view = Bundle.main.loadNibNamed("BottomViewRepositoryDetail", owner: self)?.first as? UIView else { return UIView() }

        return view
    }
    
    func setupStarsView() {
        imageDetail.image = UIImage(named: "starsImage")
        numsLabelDetail.text = "256"
        numsLabelDetail.textColor = .yellow
        nameLabelDetail.text = "stars"
    }
    
    func setupForksView() {
        imageDetail.image = UIImage(named: "forksImage")
        numsLabelDetail.text = "256"
        numsLabelDetail.textColor = .green
        nameLabelDetail.text = "forks"
    }
    
    func setupWatchersView() {
        imageDetail.image = UIImage(named: "watchersImage")
        numsLabelDetail.text = "256"
        numsLabelDetail.textColor = .cyan
        nameLabelDetail.text = "watchers"
    }
    
}
