//
//  SearchViewCell.swift
//  AssignmentTask
//
//  Created by Vignesh on 29/09/21.
//


import UIKit
import Kingfisher

class SearchViewCell: UITableViewCell {
    
    var item: Items?
    
    let repoNameLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    let openIssueCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    let avatarImg: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 5.0
        return image
    }()
    
    let starLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    let language: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(repoNameLbl)
        addSubview(userName)
        addSubview(openIssueCount)
        addSubview(avatarImg)
        addSubview(starLbl)
        addSubview(language)
        self.uiSetup()
    }
    
    private func uiSetup() {
        repoNameLbl.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        repoNameLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: 100).isActive = true
        repoNameLbl.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        userName.topAnchor.constraint(equalTo: repoNameLbl.bottomAnchor, constant: 5).isActive = true
        userName.leftAnchor.constraint(equalTo: leftAnchor, constant: 100).isActive = true
        userName.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        openIssueCount.topAnchor.constraint(equalTo: avatarImg.bottomAnchor, constant: 5).isActive = true
        openIssueCount.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        openIssueCount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        avatarImg.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        avatarImg.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        avatarImg.heightAnchor.constraint(equalToConstant: 60).isActive = true
        avatarImg.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        starLbl.topAnchor.constraint(equalTo: openIssueCount.bottomAnchor, constant: 2).isActive = true
        starLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        starLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        language.topAnchor.constraint(equalTo: starLbl.bottomAnchor, constant: 2).isActive = true
        language.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        language.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func dataMapping() {
        if let item = self.item {
            self.avatarImg.kf.setImage(with: item.owner.avatarUrl)
            self.repoNameLbl.text =  "Repository name: " + item.name
            self.userName.text =  "Owner's name: " + item.owner.login
            self.starLbl.text = "Stars: " + item.stargazersCount.description
            self.openIssueCount.text = "OpenIssueCount: " + item.openIssuesCount.description
            self.language.text = "Language: " + item.language
        }
    }
    
}

extension SearchViewCell {
    
    func cellConfig(cell: UITableViewCell) -> Self {
        cell.accessoryType = .disclosureIndicator
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.backgroundColor = .systemGray5
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 5.0
        return self
    }
    
    @discardableResult
    func set(_ item: Items?) -> Self {
        self.item = item
        self.dataMapping()
        return self
    }
    
}
