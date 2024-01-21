//
//  CustomTableViewCell.swift
//  githubRepo
//
//  Created by Vyacheslav on 04.12.2023.
//

import UIKit

// MARK: - RepositoriesListCells
class RepositoriesListCells: UITableViewCell {
    
    @IBOutlet private weak var repositoryLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private enum Languages: String {
        case swift = "Swift"
        case c_first = "C"
        case c_second = "C++"
        case c_third = "C#"
        case kotlin = "Kotlin"
        case java = "Java"
        case python = "Python"
        case html = "HTML"
        case javascript = "JavaScript"
        
        var labelColor: UIColor {
            switch self {
            case .swift:
                return .orange
            case .c_first, .c_second, .c_third:
                return .cyan
            case .kotlin:
                return .purple
            case .java:
                return .red
            case .python:
                return .green
            case .html:
                return .brown
            case .javascript:
                return .yellow
            }
        }
    }
    
    // MARK: - Public funcs
    func setRepoName(repoName: String?) {
        guard let repositoryName = repoName else { return repositoryLabel.text = "" }
        repositoryLabel.text = repositoryName
    }
    
    func setLanguage(language: String?) {
        guard let language = language else { return languageLabel.text = "" }
        languageLabel.text = language
        languageLabel.textColor = Languages(rawValue: language)?.labelColor ?? .white
    }
    
    func setDescriptionRepo(description: String?) {
        guard let description = description else { return descriptionLabel.text = "" }
        descriptionLabel.text = description
    }
    
    func setFontToLabels() {
        repositoryLabel.font = FontSettings.SFProTextMedium16
        languageLabel.font = FontSettings.SFProTextMedium12
        descriptionLabel.font = FontSettings.SFProTextMedium14
    }
    
    func hideDescriptionLabel() {
        descriptionLabel.isHidden = true
    }
}
