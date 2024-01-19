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
    
    private enum Constants {
        static let bottomViewRepoDetail = "BottomViewRepositoryDetail"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func setupBottomView(imageName: String, count: Int, title: String, color: UIColor) {
        imageDetail.image = UIImage(named: imageName)
        numsLabelDetail.text = count.intToString()
        numsLabelDetail.textColor = color
        nameLabelDetail.text = title
        nameLabelDetail.textColor = .white
        setupFontToLabels()
    }
    
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed(Constants.bottomViewRepoDetail, owner: self)?.first as? UIView else { return UIView() }

        return view
    }
    
    private func setupFontToLabels() {
        numsLabelDetail.font = UIFont(name: "SFProText-Medium", size: 16)
        nameLabelDetail.font = UIFont(name: "SFProText-Medium", size: 16)
    }
}
