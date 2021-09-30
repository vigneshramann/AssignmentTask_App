//
//  ItemModel.swift
//  AssignmentTask
//
//  Created by Vignesh on 29/09/21.
//

import Foundation

struct SearchItems: Codable {
    var items: [Items]
    
    init(items: [Items]) {
        self.items = items
    }
}

struct Items: Codable {
    var name: String
    var stargazersCount: Int
    var owner: Owner
    var openIssuesCount: Int64
    var language: String
    
    init(name: String, stargazersCount: Int, owner: Owner, openIssuesCount: Int64, language: String) {
        self.name = name
        self.stargazersCount = stargazersCount
        self.owner = owner
        self.openIssuesCount = openIssuesCount
        self.language = language
    }
}

struct Owner: Codable {
    var login: String
    var avatarUrl: URL
    var htmlUrl: URL
    
    init(login: String, avatarUrl: URL, htmlUrl: URL) {
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
    }
}
