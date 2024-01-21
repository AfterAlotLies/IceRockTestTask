//
//  bottomViewRepositoryDetail.swift
//  githubRepo
//
//  Created by Vyacheslav on 09.01.2024.
//

import UIKit

// MARK: - BottomViewRepositoryDetail
class BottomViewRepositoryDetail: UIView {
    
    @IBOutlet private weak var imageDetail: UIImageView!
    @IBOutlet private weak var numsLabelDetail: UILabel!
    @IBOutlet private weak var nameLabelDetail: UILabel!
    
    // MARK: - Constants
    private enum Constants {
        static let bottomViewRepoDetail = "BottomViewRepositoryDetail"
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
        guard let view = Bundle.main.loadNibNamed(Constants.bottomViewRepoDetail, owner: self)?.first as? UIView else { return UIView() }
        return view
    }
    
    // MARK: - Public funcs
    func setupBottomView(imageName: String, count: Int, title: String, color: UIColor) {
        imageDetail.image = UIImage(named: imageName)
        numsLabelDetail.text = count.intToString()
        numsLabelDetail.textColor = color
        nameLabelDetail.text = title
    }
    
    // MARK: - Private funcs
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        setupFontToLabels()
        nameLabelDetail.textColor = .white
    }
    
    private func setupFontToLabels() {
        numsLabelDetail.font = FontSettings.SFProTextMedium16
        nameLabelDetail.font = FontSettings.SFProTextMedium16
    }
}
